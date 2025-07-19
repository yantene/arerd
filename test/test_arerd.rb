# frozen_string_literal: true

require "test_helper"

class TestArerd < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Arerd::VERSION
  end

  def test_arerd_module_structure
    assert defined?(Arerd::Association)
    assert defined?(Arerd::ErdGenerator)
    assert defined?(Arerd::Error)
  end
end
