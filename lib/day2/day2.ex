defmodule Aoc2020.Day2 do
  def read(inputpath) do
    inputpath
    |> File.stream!([], :line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ~r/[-: ]/, trim: true))
    |> Enum.map(fn [low, high, c, pw] ->
      {String.to_integer(low), String.to_integer(high), c, pw}
    end)
  end

  def approved_password?({low, high, c, pw} = input) do
    letters_as_list = pw |> String.graphemes()
    occurrences_of_c_in_list = letters_as_list |> Enum.filter(fn l -> l == c end) |> Enum.count()

    cond do
      occurrences_of_c_in_list >= low && occurrences_of_c_in_list <= high -> true
      true -> false
    end
  end

  def is_authenticated?({expected_index, not_expected_index, c, pw} = input) do
    letters_as_list = pw |> String.graphemes()
    letter_at_expected_index = Enum.at(letters_as_list, expected_index-1)
    letter_at_not_expected_index = Enum.at(letters_as_list, not_expected_index-1)

    cond do
      (letter_at_expected_index == c &&
      letter_at_not_expected_index != c) ||
      (letter_at_expected_index != c &&
      letter_at_not_expected_index == c) -> true
      true -> false
    end
  end

  # Aoc2020.Day2.test
  def test() do
    "./lib/day2/test.txt"
    |> read
    |> Enum.count(fn x -> approved_password?(x) end)
  end

  # Aoc2020.Day2.task1
  def task1() do
    "./lib/day2/input.txt"
    |> read
    |> Enum.count(fn x -> approved_password?(x) end)
  end

  # Aoc2020.Day2.test2
  def test2() do
    "./lib/day2/test.txt"
    |> read
    |> Enum.count(fn x -> is_authenticated?(x) end)
  end

  # Aoc2020.Day2.task2
  def task2() do
    "./lib/day2/input.txt"
    |> read
    |> Enum.count(fn x -> is_authenticated?(x) end)
  end
end
