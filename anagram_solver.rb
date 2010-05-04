$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'string_ext'
require 'word_list'
require 'highline/import'
require 'optparse'
require 'win32ole'

OPTIONS = {
    filename: 'resources/wordlist.sav',
    min: 3,
    max: 6,
    style: :human,
    emulate: true
}

def reset_word_list(word_list = nil)
    puts 'Generating new wordlist from resources...'
    
    word_list = WordList.new(OPTIONS[:filename]) if word_list.nil?
    
    OPTIONS[:min] = min = ask('Minimum word length (0 for no limit, default is 3): ', Integer) { |q| q.default = 3 }
    OPTIONS[:max] = max = ask('Maximum word length (0 for no limit, default is 6): ', Integer) { |q| q.default = 6 }
    
    start_time = Time.now
    word_lists = Dir[ File.join('resources', '*') ]
    word_list.add_lists(*word_lists)
    word_list.delete_if { |w| w.length < min } if min != 0
    word_list.delete_if { |w| w.length > max } if max != 0
    puts "Generated new wordlist [Took #{"%.2f" % (Time.now - start_time)}s]"
    
    'Saving new word list'.display_as_message do
        word_list.save
    end
end

OptionParser.new do |opts|
    opts.banner = 'Usage: anagram_solver.rb [-w [WORDLIST]] [-s] [-e] [-r] [-h]'
    opts.separator 'Default: anagram_solver.rb -w resources/wordlist.sav -s human -e'
    
    opts.on('-w', '--wordlist [WORDLIST]',
            'Set the wordlist',
            '  The default is resources/wordlist.sav') do |filename|
        OPTIONS[:filename] = filename
    end

    opts.on('-s', '--style [STYLE]', [:human, :inhuman],
            'STYLE can either be "human" or "inhuman"',
            '  "human" looks more real to other players',
            '  "inhuman" is just ridiculous') do |style|
        OPTIONS[:style] = style
    end
    
    opts.on('-e', '--[no-]emulate', 
            'Emulate the keystrokes for the anagrams',
            '  Default is true') do |emulate|
        OPTIONS[:emulate] = emulate
    end
    
    opts.on_tail('-r', '--reset', 'Reset the word list set with -w') do
        reset_word_list
        exit
    end
    
    opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
    end
    
    opts.parse!(ARGV)
end

word_list = WordList.new(OPTIONS[:filename])

if word_list.exist?
    'Saved word list found, loading'.display_as_message do
        word_list.load
    end
else
    puts 'No saved word list'
    reset_word_list(word_list)
end

puts ""
puts "Word list contains #{word_list.count} words."
puts "Press Ctrl-C to exit."
puts ""

wsh = WIN32OLE.new('Wscript.Shell')

loop do
    begin
        result = ''
        found_words = []
        
        word = ask('Find anagram for: ')
        next if word.length == 0 
        
        'Searching for anagrams'.display_as_message do
            found_words = word_list.get_anagrams(word.downcase)
        end
        
        if OPTIONS[:emulate]
            puts ''
            puts '#===------------------------------===#'
            puts '#===--- STARTING IN 03 SECONDS ---===#'
            puts '#!!!---     CLICK THE GAME     ---!!!#'
            puts '#===------------------------------===#'
            
            print '#===--- '
            3.downto(1) do |i|
                print i, '.. '
                sleep 1
            end
            puts 'STARTING.. ---===#'
            puts '#===------------------------------===#', ''
            
            found_words.compact.shuffle.each_with_index do |word, index|
                word.each_char { |c|
                    if OPTIONS[:style] == :human
                        if rand(4) == 0
                            sleep 0.05
                        else
                            sleep rand
                        end
                    elsif OPTIONS[:style] == :inhuman
                        sleep 0.05
                    end
                    
                    wsh.SendKeys(c)
                    print c
                }
                wsh.SendKeys('{ENTER}')
                puts ''
                
                if OPTIONS[:style] == :human
                    if rand(4) == 0
                        sleep 0.05
                    else
                        sleep rand
                    end
                elsif OPTIONS[:style] == :inhuman
                    sleep 0.05
                end
            end
            puts ''
        else
            found_words.sort_by { |a| [ a.length, a ] }.each do |word|
                puts word
            end
            puts ''
        end
    rescue EOFError
        exit
    end
end