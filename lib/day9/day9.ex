defmodule Aoc2020.Day9 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def permutations(list), do: permutations(list, length(list))
  def permutations([], _), do: [[]]
  def permutations(_,  0), do: [[]]
  def permutations(list, i) do
    for x <- list, y <- permutations(list, i-1), do: [x|y]
  end

  def get_sum_combos(preamble, length) do
    permutations(preamble, length)
    |> Enum.map(fn x -> x |> Enum.sum() end)
  end

  defp is_valid_xmas_number(preamble, number, length) do
    get_sum_combos(preamble, length)
    |> Enum.to_list()
    |> Enum.any?(fn x -> x == number end)
  end

  defp traverse(preamble, numbers) do
    cond do

      Enum.any?(numbers) == false ->
        {:error}

      is_valid_xmas_number(preamble, numbers |> Enum.at(0), 2) == false ->
        numbers |> Enum.at(0)

      true ->
        current_number = numbers |> Enum.at(0)
        preamble = [Enum.slice(preamble, 1..Enum.count(preamble)), current_number] |> List.flatten()
        numbers = [Enum.slice(numbers, 1..Enum.count(numbers))] |> List.flatten()
        traverse(preamble, numbers)
    end
  end

  # Aoc2020.Day9.test
  def test() do
    input =
      "./lib/day9/25_number_example.txt"
      |> read()

    preamble = Enum.slice(input, 0, 5)
    numbers = Enum.slice(input, 5..Enum.count(input))
    traverse(preamble, numbers)
  end

  # Aoc2020.Day9.task1
  def task1() do
    input =
      "./lib/day9/input.txt"
      |> read()

    preamble = Enum.slice(input, 0, 25)
    numbers = Enum.slice(input, 25..Enum.count(input))
    traverse(preamble, numbers)
  end

  defp get_contigous_sets(numbers, length, i, all_sets) do
    cond do
      (i+(length-1)) == Enum.count(numbers) -> all_sets
      true ->
        set = Enum.slice(numbers, i..i+(length-1))
        all_sets = Enum.concat(all_sets, [set])
        get_contigous_sets(numbers, length, i+1, all_sets)
    end
  end

  defp find_match_in_contigous_sets(sets, value) do
    sets
    |> Enum.find(fn x -> Enum.sum(x) == value end)
  end

  defp sum_lowest_and_largets_from_contigous_set(set) do
    Enum.max(set) + Enum.min(set)
  end


  def find_contigous_set_that_sums_to_value(value, numbers, length) do
    sets = get_contigous_sets(numbers, length, 0, [])
    matching_set = find_match_in_contigous_sets(sets, value)

    cond do

      matching_set == nil ->
        find_contigous_set_that_sums_to_value(value, numbers, length+1)

      true ->
        sum_lowest_and_largets_from_contigous_set(matching_set)
    end
  end

  # Aoc2020.Day9.test2
  def test2() do
    input =
      "./lib/day9/25_number_example.txt"
      |> read()
    find_contigous_set_that_sums_to_value(test(), input, 2)
  end

  # Aoc2020.Day9.task2
  def task2() do
    input =
      "./lib/day9/input.txt"
      |> read()
    find_contigous_set_that_sums_to_value(task1(), input, 2)
  end

end
