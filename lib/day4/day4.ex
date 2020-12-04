defmodule Aoc2020.Day4 do
  def read(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n\r\n")
    |> Enum.map(fn entry ->
      Regex.split(~r/[ :]/, String.replace(entry, "\r\n", " "))
    end)
    |> Enum.map(fn entry ->
        Enum.chunk_every(entry, 2)
        |> Enum.map(fn p ->
          %{String.to_atom(Enum.at(p, 0)) => Enum.at(p, 1)}
        end)
        |> Enum.reduce(fn x, y ->
            Map.merge(x, y, fn _k, v1, v2 ->
              v2 ++ v1 end)
          end)
    end)
  end

  def has_all_obligatory_keys?(entry) do
    entry |> Map.has_key?(:byr) and
    entry |> Map.has_key?(:iyr) and
    entry |> Map.has_key?(:eyr) and
    entry |> Map.has_key?(:hgt) and
    entry |> Map.has_key?(:hcl) and
    entry |> Map.has_key?(:ecl) and
    entry |> Map.has_key?(:pid)
  end

  # Aoc2020.Day4.test
  def test() do
    passportdata = "./lib/day4/test.txt" |> read
    Enum.count(passportdata, fn entry -> has_all_obligatory_keys?(entry) end)
  end

    # Aoc2020.Day4.task1
    def task1() do
      passportdata = "./lib/day4/input.txt" |> read
      Enum.count(passportdata, fn entry -> has_all_obligatory_keys?(entry) end)
    end
end
