defmodule Aoc2020.Day6 do

  def read(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n\r\n")
    |> Enum.map(fn entry ->
      String.replace(entry, "\r\n", "")
      |> String.graphemes()
      |> Enum.uniq()
    end)
  end

  # Aoc2020.Day6.task1
  def task1() do
    "./lib/day6/input.txt"
     |> read()
     |> Enum.map(fn entry -> Enum.count(entry) end)
     |> Enum.sum()
  end

end
