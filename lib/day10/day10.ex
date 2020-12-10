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

    x = IO.inspect(traverse_and_count(input, 0, 0, 0, 0, 3))
    x.one_diff * x.three_diff
  end

  def get_paths_rec(array, current, result) do
    case Enum.any?(array) do
      false ->
        result

      true ->
        next = array |> Enum.at(0)

        case next - current < 3 do
          true ->
            result = (result || []) |> Enum.concat([next])
            [_ | array] = array
            get_paths_rec(array, next, result)

          false ->
            result
        end
    end
  end

  def get_paths_rec(array, grps) do
    [h | _t] = array
    grp = get_paths_rec(array, h, [])
    grps = grps |> Enum.concat([grp])
    new_array = Enum.slice(array, Enum.count(grp)..Enum.count(array))

    case Enum.empty?(new_array) do
      true -> grps
      false -> get_paths_rec(new_array, grps)
    end
  end

  def count_valid_paths(group) do
    Comb.subsets(group)
    |> Enum.filter(fn x -> Enum.empty?(x) == false end)
    |> Enum.filter(fn x ->
      Enum.any?(x, fn z -> z == List.first(group) end) and
        Enum.any?(x, fn z -> z == List.last(group) end)
    end)
    |> Enum.filter(fn x ->
      Enum.chunk_every(x, 2, 1, :discard)
      |> Enum.all?(fn a ->
        n = (Enum.at(a, 1) - Enum.at(a, 0)) |> Kernel.abs()
        n <= 3
      end)
    end)
    |> Enum.count()
  end

  def part2(input) do
    get_paths_rec([0] ++ input, [])
    |> Enum.map(&count_valid_paths/1)
    |> Enum.reduce(fn a, b -> a * b end)
  end

  # Aoc2020.Day10.task2_small_test
  def task2_small_test do
    "./lib/day10/small_test.txt"
    |> read()
    |> part2
  end

  # Aoc2020.Day10.task2_larger_test
  def task2_larger_test do
    "./lib/day10/larger_test.txt"
    |> read()
    |> part2
  end

  # Aoc2020.Day10.task2
  def task2 do
    "./lib/day10/input.txt"
    |> read()
    |> part2
  end
end
