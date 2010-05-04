require 'string_ext'

class WordList < Array
    attr :filename
    
    def initialize(filename)
        @lists = []
        @filename = filename
    end
    
    def save
        File.open(@filename, 'w+') { |f| Marshal.dump(self, f) }
    end
    
    def load
        if exist?
            file = File.open(@filename, 'r')
            
            replace Marshal.load(file)
        end
    end
    
    def exist?
        File.exist?(@filename)
    end
    
    def add_list(filename, &block)
        unless @lists.include?(filename)
            filename.display_as_message do
                @lists << filename
                concat File.readlines(filename).collect { |w| w.downcase.strip }
                uniq!
            end
        end
    end
    
    def add_lists(*filenames)
        filenames.each do |filename|
            add_list(filename)
        end
    end
    
    def first_anagram(other_word)
        find { |word|
            other_word.contains?(word)
        }
    end
    
    def get_anagrams(other_word)
        find_all { |word|
            other_word.contains?(word)
        }
    end
end