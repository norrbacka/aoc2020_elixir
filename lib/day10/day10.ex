defmodule Aoc2020.Day10 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.sort()
  end

  def traverse_and_count(inputs, current_jolt, one_diff, two_diff, three_diff, max_steps) do
    next_adapter =
      inputs
      |> Enum.find(fn input -> input - current_jolt <= max_steps end)

    IO.inspect(%{
      :current_jolt => current_jolt,
      :next_adapter => next_adapter,
      :one_diff => one_diff,
      :two_diff => two_diff,
      :three_diff => three_diff
    })

    cond do
      next_adapter == nil ->
        final_adapter = current_jolt + 3

        %{
          :final_adapter => final_adapter,
          :one_diff => one_diff,
          :two_diff => two_diff,
          :three_diff => three_diff + 1
        }

      next_adapter - current_jolt == 1 ->
        {_, new_input} = inputs |> Enum.split_with(fn y -> y == next_adapter end)
        traverse_and_count(new_input, next_adapter, one_diff + 1, two_diff, three_diff, max_steps)

      next_adapter - current_jolt == 2 ->
        {_, new_input} = inputs |> Enum.split_with(fn y -> y == next_adapter end)
        traverse_and_count(new_input, next_adapter, one_diff, two_diff + 1, three_diff, max_steps)

      next_adapter - current_jolt == 3 ->
        {_, new_input} = inputs |> Enum.split_with(fn y -> y == next_adapter end)
        traverse_and_count(new_input, next_adapter, one_diff, two_diff, three_diff + 1, max_steps)
    end
  end

  # Aoc2020.Day10.small_test
  def small_test() do
    input =
      "./lib/day10/small_test.txt"
      |> read()

    traverse_and_count(input, 0, 0, 0, 0, 3)
  end

  # Aoc2020.Day10.larger_test
  def larger_test() do
    input =
      "./lib/day10/larger_test.txt"
      |> read()

    traverse_and_count(input, 0, 0, 0, 0, 3)
  end

  # Aoc2020.Day10.task1
  def task1() do
    input =
      "./lib/day10/input.txt"
      |> read()

    x = IO.inspect traverse_and_count(input, 0, 0, 0, 0, 3)
    x.one_diff * x.three_diff
  end

end
