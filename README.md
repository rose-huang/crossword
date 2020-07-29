Rose Huang (rh2805) and Biqing Qiu (bq2134)

**Description:** We created a crossword solver for a crossword board with no hints. Given a board with blanks and blacked out boxes, we searched for the right words to place into the blanks using brute force, and then introduced parallelism. We selected words of the right length from a dictionary text file and verified that the solution is right by checking for collisions. We return all possible solutions.

**Data:** We are using three test crossword puzzles found online (references below). The crossword puzzles are 6x9, 7x7 and 9x9 respectively. The word pool used for the search is a dictionary of 60 words containing all words used in the solutions of the three crossword puzzles (so each returns at least one solution) plus 20 most common medium-length and short English words found online. We also created a test with no solution of a very small crossword with a very small dictionary of 3 words to verify that our crossword solver still works when there are no solutions. 

**Strategy:** Fitting words of the right length to board: From the given blanks, which we represent as the data type Sites with data constructors squares ((x,y) coordinates) and len, we fit words from the dictionary of the right length into the blank using recursion. Each time we recurse, we place a word of the right length into the blank and then check against the already filled sites to verify that each square has only one letter. We do this verification by taking the returned solution, a list of tuples of Strings and Sites, and check that at each square there is no collision of letters; if so, we filter out the solution. We recurse until our base case, which is when there are no blanks left to fill. 

**Verifying Solution:** We verify our solution as we fill in the blanks, pruning out solutions that have collisions of different letters in the same blank, as described in our strategy. If there isn’t a solution with the given dictionary, our crossword solver returns nothing. If there are multiple solutions, we return all of the unique solutions.

**Parallelizing the Solver:** After obtaining a list of candidate words of the right length for a blank, we use parPair to parallelize the solver to continue the search with half the list per thread. Our parallelization essentially breaks a tree search into two different branches at each level and solves the branches in parallel. We use rpar to evaluate to WHNF, which is adequate for our application.


**How to run:**

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
