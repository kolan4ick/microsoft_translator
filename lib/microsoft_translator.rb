# frozen_string_literal: true

require_relative "microsoft_translator/version"
require 'net/http'
require 'json'

module MicrosoftTranslator
  class TranslationApi
    def initialize(subscription_key = nil, region = nil)
      @subscription_key = subscription_key
      @region = region
    end

    def translate(text, to, from = nil)
      uri = URI("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=#{to}")
      uri.query = URI.encode_www_form({ "api-version" => "3.0", "to" => to })
      request = Net::HTTP::Post.new(uri)

      # Use subscription key and region if provided, otherwise use configured values
      request["Ocp-Apim-Subscription-Key"] = @subscription_key || MicrosoftTranslator.configuration.subscription_key
      request["Ocp-Apim-Subscription-Region"] = @region || MicrosoftTranslator.configuration.region

      request["Content-type"] = "application/json"
      request.body = [{ "Text" => text }].to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do | http |
        http.request(request)
      end

      # Get only the first translation
      JSON.parse(response.body)[0]["translations"][0]["text"]
    end
  end
end
