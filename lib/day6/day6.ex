defmodule Aoc2020.Day6 do
  def read(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n\r\n")
  end

  # Aoc2020.Day6.task1
  def task1() do
    "./lib/day6/input.txt"
    |> read()
    |> Enum.map(fn entry ->
      String.replace(entry, "\r\n", "")
      |> String.graphemes()
      |> Enum.uniq()
    end)
    |> Enum.map(fn entry -> Enum.count(entry) end)
    |> Enum.sum()
  end

  def letter_is_in_entry(entry, letter) do
    Enum.any?(entry, fn c -> c == letter end)
  end

  def count_questions_all_in_group_said_yes_to(group) do
    Enum.filter(group.letters, fn letter ->
      everyone_has_letter = Enum.all?(group.answers, fn entry ->
        letter_is_in_entry(entry, letter)
      end)
      everyone_has_letter
    end)
    |> Enum.count()
  end

  # Aoc2020.Day6.task2
  def task2() do
    groups = "./lib/day6/input.txt"
    |> read()
    |> Enum.map(fn entry ->
      %{
        :answers =>
          entry
          |> String.split("\r\n")
          |> Enum.map(&String.graphemes/1),
        :letters =>
          String.replace(entry, "\r\n", "")
          |> String.graphemes()
          |> Enum.uniq()
      }
    end)
    Enum.map(groups, fn group ->
      count_questions_all_in_group_said_yes_to(group)
    end)
    |> Enum.sum()
  end
end
