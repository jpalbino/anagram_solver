require 'test/unit'
require 'string_ext'

class TestStringExt < Test::Unit::TestCase    
    def test_contains?
        word = "dtsepa"
        
        assert word.contains?("paste")
        assert word.contains?("pasted")
        assert word.contains?("date")
        assert word.contains?("tad")
        
        refute word.contains?("paster")
        refute word.contains?("jump")
        refute word.contains?("part")
        refute word.contains?("sneeze")
    end
end