PFP Final Project
Names: Rose Huang (rh2805) and Biqing Qiu (bq2134)

How to run:

To build with the appropriate dependencies:
stack build
stack ghc -- -O2 -threaded -eventlog -rtsopts --make -Wall -O crosswordSolver.hs

For test 1 with 1 core:
time ./crosswordSolver words60.txt test_site1.txt +RTS -ls -N1

For test 2 with 1 core:
time ./crosswordSolver words60.txt test_site2.txt +RTS -ls -N1

For test 3 with 1 core:
time ./crosswordSolver words60.txt test_site3.txt +RTS -ls -N1

For the tests with no solution with 1 core:
time ./crosswordSolver test_dict_no_solution.txt test_site_no_solution.txt +RTS -ls -N1

To run with more than 1 core, simply update -N# with # of cores.

Dictionary of common words are from:
https://github.com/first20hours/google-10000-english

Crossword puzzles are from:
http://www.printactivities.com/Crosswords/9x9-Easy-Crosswords/9x9Crossword-Grid1-0004-Soln.html#.XfqXmNZKjUp
http://www.ic.unicamp.br/~meidanis/courses/mc336/problemas-prolog/p99a.dat
https://thepuzzlecompany.biz/puzzles/Beginners.jpg
