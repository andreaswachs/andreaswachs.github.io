---
author: Andreas Wachs
title: Creating a number guesser in Haskell using a FSA and binary search
date: 2021-09-11
description: Thoughts on an implementation of a state machine that guesses a number between 1 and 1000 with binary search
tags: [ haskell, algorithms]
---

<!--  Creating a number guesser in Haskell using a FSA and binary search -->

# Introduction

The coding event [*Programmeringshøst 2021*](https://itustudent.itu.dk/Event?id=%7BD788F417-9BF3-479B-BD6A-82A445DCD37A%7D) has been announced at ITU for this year. The goal of this 
event is for ITU students that are new to programming to get experience with problem solving and actual 
programming. This event uses [Kattis](https://open.kattis.com/) as the platform to host problems and it is 
also the place where solutions are submitted and judged.

At the time of writing I am now a 2nd year student, so I am not part of the main target audience. But! - I 
am going to take the opportunity to participate by using Haskell - a language which I have spent some 
months, on the side, using, after my discrete mathematics professor recommended it.

This post covers one of the warm-up problems, that students can try out before the actual event starts.

**Warning**: This solutions might just be completely over engineered in comparison to solutions that could be
made in imperative/OO languages - but this has been a perfect opportunity to use tools that Haskell provides
to create an expressive solution that read well (*quoted from the author*).

# Table of Contents

- [Introduction](#introduction)
- [Table of Contents](#table-of-contents)
  - [Guess a number.. between 1 and 1000 with 10 tries](#guess-a-number-between-1-and-1000-with-10-tries)
  - [Finite State Automatons](#finite-state-automatons)
  - [Defining states of the FSA](#defining-states-of-the-fsa)
  - [Making guesses](#making-guesses)
  - [Reading the answer](#reading-the-answer)
  - [Interpreting the answer](#interpreting-the-answer)
  - [Finishing up](#finishing-up)
    - [Complete source code](#complete-source-code)

## Guess a number.. between 1 and 1000 with 10 tries

[The problem is called *guess*](https://itu.kattis.com/problems/guess), in which you have to write a program that must correctly guess an unknown number (to us) in 10 tries or less. 

The advantage of having completed the 2nd semester at ITU is that you went though the *Algorithms and Data structures* course, in which you learned about *binary search*. This is a way of searching in which you can find what you're looking for in a sorted list/array in approximately $\lg(N)$ tries, where $N$ is the number of things you have to search through.

The *binary search* algorithm comes in cluch to save us, as we're going to be guessing a number from 1 to 1000, where each guess gets a reply of either *"lower"*, *"higher"* or *"correct"*, thus enabling us to use it.

## Finite State Automatons

Finite State Automatons, or *FSA*'s between friends, is a way of writing a program that reacts to input and can change state depending on the input. This can lead to the program to enter a certain state at the end of the given input, such that the program can judge whether the input lives up to certain rules.

This way of thinking is useful in this program, as the program has the make guesses and react to the response. Of course, to complete this coding challenge the program must always reach a state where it manages to correctly guess the unknown number.

Riding off the [Knuth-Morris-Pratt string matching algorithm](https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/), we can create FSAs that have impressive runtime performance for dealing with certain kinds of problems.

## Defining states of the FSA

The different actions that the program should perform is *making guesses*, *read the response* and *decide the next step*. The *decide the next step* state should also be a state that allows for successful termination.

The expressiveness of solving problems in Haskell comes to our aid, as we can define our own algebraic data types which can model the solution space from the application space really nicely.

We define a type for the state and a type for the data that is carried around:

```haskell
data State = MakeGuess StateData
            | ReadInput StateData
            | DecideNextStep StateData

data StateData = StateData { lo :: Integer
                           , mid :: Integer
                           , hi :: Integer
                           , input :: String
                           }
```

With this design, can have high cohesion and low coupling, as we could make changes to the `StateData` data type, without thinking much about it in our `State` data type.

## Making guesses

For the program state where we want to make a guess, a guess needs to already be determined to make. We use the "mid" value from the binary search algorithm, as it is the value that is used to attempt to find the given value.

This idea is taken from [Sedgewick and Wayne's implementation of Binary Search](https://algs4.cs.princeton.edu/11model/BinarySearch.java.html).

We then make the guessing function:

```haskell
makeGuess :: State -> IO ()
makeGuess state =
    case state of
        MakeGuess stateData -> do
            printf "%d\n" (mid stateData)
            hFlush stdout
            act $ ReadInput stateData
            return ()
        _ -> do
            exitFailure
```

This functions only accepts the state `MakeGuess`, where it will print the guess, flush the output (this is due to the way this single problem is judged) and then it makes the program change state to receive a response.

## Reading the answer

After making each guess, the judge will then decide if we guessed correctly, or if we need to make a new guess that is lower or higher.

We can express this logic by this:

```haskell
readInput :: State -> IO ()
readInput state =
    case state of
        ReadInput stateData -> do
            line <- getLine
            act $ DecideNextStep stateData {input=line}
            return ()
        _ -> do
            exitFailure
```

I decided that in order to practice a bit of *clean code*, I didn't want to interpret the input from the judge in this function. That is left for the function that controls the next step in the execution.

The input from the judge is saved in the state data, such that it is neatly carried with the execution of the next function.

## Interpreting the answer

The answer from the judge was given before, but not interpreted. We implement a function `decideNextStep` which interprets the input and acts on it.

```haskell
decideNextStep :: State -> IO ()
decideNextStep state =
    case state of
        DecideNextStep stateData ->
            case input stateData of
                "lower" -> goLower stateData
                "higher" -> goHigher stateData
                "correct" -> return ()
                _ -> exitFailure
        _ -> exitFailure
```

Here the next steps in the execution is decided, with help of the helper functions `goLower`and `goHigher` which will modify the numbers `lo`, `mid` and `hi` data in the state data to decide the next guess. This code is a *tad* not-so-clean.

```haskell
goLower :: StateData -> IO ()
goLower stateData =
    act $ MakeGuess 
        stateData { lo=lo stateData
                  , mid=calcMid (lo stateData) ((mid stateData) - 1)
                  , hi=(mid stateData) - 1
                  }

goHigher :: StateData -> IO ()
goHigher stateData =
    act $ MakeGuess 
        stateData { lo=(mid stateData) + 1
                  , mid=calcMid ((mid stateData) + 1) (hi stateData)
                  , hi=hi stateData
                  }

calcMid :: Integer -> Integer -> Integer
calcMid l h = l + (h - l) `div` 2
```

The `goLower`and `goHigher` functions is my implementation of what is going on inside of a imperative implementation of the *binary search algorithm*'s `while` loop. The `calcMid` function calculates the middle between the `hi`and `lo` value.

## Finishing up

The only thing left is to start our state machine on program startup, when the program is executed on the Kattis judging server:

```haskell
main :: IO ()
main = act $ MakeGuess (StateData {lo=1, mid=500, hi=1000, input=""})
```

This whole problem starts off by the program making a guess and it starts at the middle of the limits of the number that can be guessed: 1 and 1000. 

This implementation achieved a solution with the running time of $0.01$ seconds, which at the time of writing placed this solution as the fastest *Haskell* solution and the 6th fastest solution overall, only surpassed by fellow students or professors who used C/C++ and Rust.

### Complete source code

Here is the complete, self contained source file with the proper library imports as well.

```haskell
import Text.Printf
import System.Exit
import System.IO

data State = MakeGuess StateData
            | ReadInput StateData
            | DecideNextStep StateData

data StateData = StateData { lo :: Integer
                           , mid :: Integer
                           , hi :: Integer
                           , input :: String
                           }

act :: State -> IO ()
act state =
    case state of
        MakeGuess {}      -> makeGuess state
        ReadInput {}      -> readInput state
        DecideNextStep {} -> decideNextStep state


makeGuess :: State -> IO ()
makeGuess state =
    case state of
        MakeGuess stateData -> do
            printf "%d\n" (mid stateData)
            hFlush stdout
            act $ ReadInput stateData
            return ()
        _ -> do
            exitFailure

readInput :: State -> IO ()
readInput state =
    case state of
        ReadInput stateData -> do
            line <- getLine
            act $ DecideNextStep stateData {input=line}
            return ()
        _ -> do
            exitFailure

decideNextStep :: State -> IO ()
decideNextStep state =
    case state of
        DecideNextStep stateData ->
            case input stateData of
                "lower" -> goLower stateData
                "higher" -> goHigher stateData
                "correct" -> return ()
                _ -> exitFailure
        _ -> exitFailure


goLower :: StateData -> IO ()
goLower stateData =
    act $ MakeGuess 
        stateData { lo=lo stateData
                  , mid=calcMid (lo stateData) ((mid stateData) - 1)
                  , hi=(mid stateData) - 1
                  }

goHigher :: StateData -> IO ()
goHigher stateData =
    act $ MakeGuess 
        stateData { lo=(mid stateData) + 1
                  , mid=calcMid ((mid stateData) + 1) (hi stateData)
                  , hi=hi stateData
                  }

calcMid :: Integer -> Integer -> Integer
calcMid l h = l + (h - l) `div` 2

main :: IO ()
main = act $ MakeGuess (StateData {lo=1, mid=500, hi=1000, input=""})
```
