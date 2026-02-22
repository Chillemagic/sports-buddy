class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)
    message = chat.messages.last

    # Build options with attachments
    options = build_multimodal_options(message)
    Rails.logger.info("Chat options: #{options.inspect}")

    # Create assistant message to collect response
    assistant_message = chat.messages.build(role: "assistant", content: "")
    assistant_message.save!

    response_content = ""

    chat.ask(content, with: options) do |chunk|
      Rails.logger.info("Received chunk: #{chunk.inspect}")
      if chunk.content && !chunk.content.blank?
        response_content += chunk.content
        assistant_message.broadcast_append_chunk(chunk.content)
      end
    end
    Rails.logger.info("Final response content: #{response_content}")
    assistant_message.update!(content: response_content)
  rescue => e
    Rails.logger.error("ChatResponseJob failed: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end

  private

  def build_multimodal_options(message)
    return {} unless message.attachments.attached?

    options = {}

    message.attachments.each do |attachment|
      file_path = get_attachment_path(attachment)
      content_type = attachment.blob.content_type

      if content_type.start_with?("application/pdf")
        options[:pdf] = file_path
      elsif content_type.start_with?("image/")
        options[:image] = file_path
      elsif content_type.start_with?("audio/")
        options[:audio] = file_path
      end
    end

    options
  end

  def get_attachment_path(attachment)
    # For Cloudinary, use the signed URL
    if attachment.service.is_a?(ActiveStorage::Service::CloudinaryService)
      attachment.blob.service_url(expires_in: 1.hour)

    elsif attachment.service.respond_to?(:path_for)
      # Local Storage
      attachment.service.path_for(attachment.key)
    else
      # For other storage backends, download to temp and get path
      file = attachment.download
      temp_file = Tempfile.new([attachment.blob.filename.base, ".#{attachment.blob.filename.extension}"])
      temp_file.write(file)
      temp_file.close
      temp_file.path
    end
  end
end
