# anagram_solver

Enter an anagram and this will return a list of words contained within the anagram.

The emulate option is really cool, especially when playing online anagram solving games.

## Install

    > git clone git@github.com:c00lryguy/anagram_solver.git
    > cd anagram_solver

## Options

`-w, --wordlist [WORDLIST]`
> Set the wordlist
> > The default is resources/wordlist.sav

`-s, --style [STYLE]`
> STYLE can either be "human" or "inhuman"
> > "human" looks more real to other players
> > "inhuman" is just ridiculous
> > Default is "human"

`-e, --[no-]emulate`
> Emulate the keystrokes for the anagrams
> > Default is true

`-r, --reset`
> Reset the word list set with -w

`-h, --help`
> Display help

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.