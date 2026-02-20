require "ruby_llm/providers/openai"

RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"] || Rails.application.credentials.dig(:openai_api_key)
  config.gemini_api_key = ENV["GEMINI_API_KEY"] || Rails.application.credentials.dig(:gemini_api_key)
  # config.default_model = "gpt-4.1-nano"
  config.default_model = "gpt-4.1-mini-2025-04-14"
  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end

# Multi modal:

# For PDF
# chat = Chat.create(model: "gemini-3-flash-preview")
# prompt = "Analyse this pdf"
# response = chat.ask(prompt, with: {pdf: "tmp/Active\ Record\ Migrations.pdf"})

# For Image
# chat = RubyLLM.chat(model: "gpt-4o")
# prompt = "Explain this error"
# response = chat.ask(prompt, with: {image: "tmp/Screenshot.png"})

# For audio
# chat = RubyLLM.chat(model: "gpt-4o-audio-preview")
# prompt = "Could you describe the content of this audio file?
