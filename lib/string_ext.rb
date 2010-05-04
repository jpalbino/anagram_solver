class String
    def contains?(other_word)
        !Regexp.new(other_word.to_anagram_key.split("").join(".*")).match(self.to_anagram_key).nil?
    end
    
    def to_anagram_key
        split('').sort.join('').strip
    end
    
    def display_as_message(&block)
        start_time = Time.now
        print self + '... '
        block.call
        puts "Done. [Took #{"%.2f" % (Time.now - start_time)}s]"
    end
end