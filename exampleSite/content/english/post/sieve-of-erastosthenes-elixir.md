---
author: Andreas Wachs
title: Implementing the Sieve of Eratosthenes in Elixir
date: 2021-05-09
description: A showcase of an implementation of the Sieve of Eratosthenes in Elixir
tags: [ elixir, algorithms]
---


## Table of Contents
- [Table of Contents](#table-of-contents)
- [Quick explanation of the Elixir programming language](#quick-explanation-of-the-elixir-programming-language)
- [Sieve of Eratosthenes: the algorithm](#sieve-of-eratosthenes-the-algorithm)
- [Sieve of Eratostenes: an Elixir implementation](#sieve-of-eratostenes-an-elixir-implementation)
  - [Creating a fitting API](#creating-a-fitting-api)
  - [The meat of the algorithm](#the-meat-of-the-algorithm)
  - [Rounding off](#rounding-off)
  - [The complete source code](#the-complete-source-code)

## Quick explanation of the Elixir programming language

Elixir is a dynamically typed, general-purpose programming language. The syntax of the Elixir programming language bears heavy influence from Ruby, Clojure and Erlang. It runs on the BEAM virtual machine, which is implemented in Erlang. As of this moment, spring 2021, the Elixir programming language has turned 10 years old. If you're interested, you should read the [Wikipedia article](https://en.wikipedia.org/wiki/Elixir_(programming_language)) about the programming language to learn more.

## Sieve of Eratosthenes: the algorithm

**Overview:** 
The Sieve of Eratosthenes is an algorithm for finding primes within a certain range. The algorithm only works if the range starts at $2$, but we can through programming provide users with the ability to give any arbitrary range, but we still need to do the work as if the user requested primes starting from a number larger than $2$.
  
The algorithm works by starting with a list of all the integers from 2 to a certain limit. It is known that $2$ is the first prime number, and it happens to be the first number in or list of numbers. We then remove all numbers that are multiples of two, which incidentally is all [composite numbers](https://en.wikipedia.org/wiki/Composite_number). When all the multiples of $2$ have been removed, we take the next number in the list, which must then also be a prime. We rinse and repeat this process until we have removed all the multiples of all the iteratively remaining numbers.

I can attempt to describe this in a more mathematical sense:

1. We create a set containing distinct integers from $2$ to $n$, for some $n$ that the user inputs: $S = \lbrace x | x \in [2;n] \rbrace$ where $x$ is a positive integer.
2. We then (iteratively) transform the set such that we remove the smallest found prime number's multiples: $S' = \lbrace x  |  x \in S  \land \neg(s_0  |  x) \rbrace$. Whilst doing this, we maintain another set of integers, the accumulated prime numbers $A$, where we after each iteration add $s_0$: $A = A \cup  \lbrace s_0 \rbrace$. Furthermore, we need to remove the first element $s_0$ from $S$ such that the next first element will be the next prime number. 
3. When we've iterated over the entire set $S$, such that the set $S$ will become empty, we've found all the primes that were to be found in that number range. The set accumulated prime set $A$ should then hold all the prime numbers in that rage.

This is currently the best math-flavored explanation that I can give. If I'm completely in the wrong feel free to contact me.

{{< figure src="https://upload.wikimedia.org/wikipedia/commons/b/b9/Sieve_of_Eratosthenes_animation.gif" alt="image" caption="By SKopp at German Wikipedia on the Sieve of Erastosthenes" >}}

## Sieve of Eratostenes: an Elixir implementation


### Creating a fitting API
To start off; I would like to apply some *client-server* architecture to the implementation, such that clients of the API will only be able to make calls the the "surface level" functions, that provide numbers. All intermediate functions that helps in creating a list of primes is set *private* such that the user cannot hurt themselves.

I begin with defining the public API:

```elixir
defmodule Primes do

  def get(%{from: from, to: to}) do
    cond do
      to >= 2 and to >= from -> {:ok, sieve(from, to)}
      to < from -> error("Your upper bound is less than the lower bound.")
      to < 2 -> error("There are no primes less than 2.")
      true -> error("Uncaught error. Check your input.")
    end
  end

  # Handle the case when only to: is given
  def get(%{to: _to} = arg) do
    get(Map.put(arg, :from, 2))
  end

  def get(%{from: _from}) do
    # Handle the case when only from: is given
    error(~S(No "to:" value provided.))
  end

    defp error(msg) do
    {:error, msg}
  end

end
```

This code is not particularly interesting but it provides the client with a flexible API. Results will always be a tuple of an atom indicating either `:ok` or `:error`, such that the second value of the tuple can be correctly interpreted.

### The meat of the algorithm

We can define the function `sieve/2` to take two lists as parameters: firstly, the list of numbers that is being worked on (set $S$ from before) and the accumulating list, where only primes numbers are added (set $A$ from before).

```elixir
defp sieve([n | ns], acc) do
    sieve(Enum.filter(ns, 
        fn x -> rem(x, n) != 0 end), 
        [n | acc])
end

defp sieve([], acc) do
    acc
end
```

By using the forever wonderful `Enum.filter/2` function, we can easily remove multiples of the first number. With some clever pattern matching, we can separate the first element of set $S$ and remove all multiples of that from the rest of the list.

The `sieve/2` function calls itself recursively. To prevent infinite recursive calls, we utilize pattern matching by the second definition of the `sieve/2` function, such that when $S$ is empty, the accumulated list is returned without any computation.

Since we allow the client to specify the range of witch they want primes returned within, we need to do a whole lot more work. For those who paid careful attention to the code before, they realize that we called `sieve/2` in the `get/1` function further above, but the parameters `from` and `to` were numbers. We have our intermediate `sieve/2` function for two numbers here:

```elixir
defp sieve(a, b) when is_number(a) and is_number(b) do
    Enum.to_list(2..b)
    |> sieve([])
    |> Enum.reverse()
    |> show_primes_in_range(a)
end
```

We are now faced with the next interesting part of this implementation: prime numbers are pushed in front of the accumulated list. This is because it is the fastest insertion method, as opposed to add it to the end of the list. In the end, the list of prime numbers comes out in reverse order. This is what `Enum.reverse/1` takes care of.

We finish by ensuring that the client only is returned the prime numbers in the range that they requested. Here, we implement the `show-primes_in_range/2` function:

```elixir
defp show_primes_in_range([p | ps] = primes, lower_bound) do
  cond do
    lower_bound == 2 -> primes
    p >= lower_bound -> primes
    true -> show_primes_in_range(ps, lower_bound)
  end
end
```

Here, we throw away off the numbers, starting from the beginning of time primes list, if they are smaller than the lower bounds. When we reach a list of prime numbers where the first number is larger than the lower bound, we return that list. This is to ensure that the worst case running time is linear in the list of primes. If we were to resort something like `Enum.filter/2`, to filter out all values less than the lower bounds, we would be guaranteed to always have linear running time for this work.

### Rounding off

Thank you for the read! As of writing, I've just started learning about the Elixir programming language and are looking to work with it as a student software developer in a professional setting. I'm trying to improve my learning by writing about what I've practiced, to share what I've made and trick myself into looking at the source code I've produced multiple times, as a way to find better solutions and discover edge cases and bugs.

### The complete source code

```elixir
defmodule Primes do
  @moduledoc """
  This module provides an API (the get function) to
  efficiently generate lists of prime numbers.
  """


  @doc """
  This is the client API for getting a list of primes
  The primes are found with the Sieve Of Eratosthenes algorithm
  """
  @spec get(%{:to => any, optional(any) => any}) :: {:error, []} | {:ok, list()}
  def get(%{from: from, to: to}) do
    cond do
      to >= 2 and to >= from -> {:ok, sieve(from, to)}
      to < from -> error("Your upper bound is less than the lower bound.")
      to < 2 -> error("There are no primes less than 2.")
      true -> error("Uncaught error. Check your input.")
    end
  end

  def get(%{to: _to} = arg) do
    get(Map.put(arg, :from, 2))
  end

  def get(%{from: _from}) do
    error(~S(No "to:" value provided.))
  end

  defp sieve(a, b) when is_number(a) and is_number(b) do
    Enum.to_list(2..b)
    |> sieve([])
    |> Enum.reverse()
    |> show_primes_in_range(a)
  end

  defp sieve([n | ns], acc) do
    sieve(Enum.filter(ns,
      fn x -> rem(x, n) != 0 end), [n | acc])
  end

  defp sieve([], acc) do
    acc
  end

  defp show_primes_in_range([p | ps] = primes, lower_bound) do
    cond do
      lower_bound == 2 -> primes
      p >= lower_bound -> primes
      true -> show_primes_in_range(ps, lower_bound)
    end
  end

  defp error(msg) do
    {:error, msg}
  end
end
```
