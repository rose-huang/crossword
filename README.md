How to run:

stack build
stack ghc -- -O2 -threaded -eventlog -rtsopts --make -Wall -O crosswordSolver.hs
time ./crosswordSolver words76.txt test_site1.txt +RTS -ls -N1
../threadscope.osx crosswordSolver.eventlog

Dictionary of common words are from:
https://github.com/first20hours/google-10000-english

Crossword puzzles are from:
http://www.printactivities.com/Crosswords/9x9-Easy-Crosswords/9x9Crossword-Grid1-0004-Soln.html#.XfqXmNZKjUp
http://www.ic.unicamp.br/~meidanis/courses/mc336/problemas-prolog/p99a.dat
https://thepuzzlecompany.biz/puzzles/Beginners.jpg
