# frozen_string_literal: true

require "test_helper"
require 'minitest/autorun'

class TestMicrosoftTranslator < Minitest::Test
  def test_that_it_can_translate
    translator = MicrosoftTranslator::TranslationApi.new(ENV.fetch("TRANSLATOR_SUBSCRIPTION_KEY"), ENV.fetch("TRANSLATOR_REGION"))

    translation = translator.translate("Hello", "es", "en")
    assert_equal "Hola", translation
  end
end
