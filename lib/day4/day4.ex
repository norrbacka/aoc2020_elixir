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

  def valid_byr?(entry) do
    Regex.match?(~r/[0-9]{4}/, entry.byr) and
    String.to_integer(entry.byr) >= 1920 and
    String.to_integer(entry.byr) <= 2002
  end

  def valid_iyr?(entry) do
    Regex.match?(~r/[0-9]{4}/, entry.iyr) and
    String.to_integer(entry.iyr) >= 2010 and
    String.to_integer(entry.iyr) <= 2020
  end

  def valid_eyr?(entry) do
    Regex.match?(~r/[0-9]{4}/, entry.eyr) and
    String.to_integer(entry.eyr) >= 2020 and
    String.to_integer(entry.eyr) <= 2030
  end

  def valid_hgt?(entry) do
    cond do
      Regex.match?(~r/cm/, entry.hgt) ->
        cms = entry.hgt |> String.split("cm") |> Enum.at(0) |> String.to_integer
        cms >= 150 and cms <= 193
      Regex.match?(~r/in/, entry.hgt) ->
        ins = entry.hgt |> String.split("in") |> Enum.at(0) |> String.to_integer
        ins >= 59 and ins <= 76
      true -> false
    end
  end

  def valid_hcl?(entry) do
    Regex.match?(~r/^#[a-f0-9]{6}$/, entry.hcl)
  end

  def valid_ecl?(entry) do
    entry.ecl == "amb" or
    entry.ecl == "blu" or
    entry.ecl == "brn" or
    entry.ecl == "gry" or
    entry.ecl == "grn" or
    entry.ecl == "hzl" or
    entry.ecl == "oth"
  end

  def valid_pid?(entry) do
    Regex.match?(~r/^[0-9]{9}$/, entry.pid)
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

    def test_invalid() do
      passportdata = "./lib/day4/invalid.txt" |> read
      Enum.count(passportdata, fn entry ->
        has_all_obligatory_keys?(entry) and
        valid_byr?(entry) and
        valid_iyr?(entry) and
        valid_eyr?(entry) and
        valid_hgt?(entry) and
        valid_hcl?(entry) and
        valid_ecl?(entry) and
        (valid_pid?(entry))
      end)
    end

    def test_valid() do
      passportdata = "./lib/day4/valid.txt" |> read
      Enum.count(passportdata, fn entry ->
        has_all_obligatory_keys?(entry) and
        valid_byr?(entry) and
        valid_iyr?(entry) and
        valid_eyr?(entry) and
        valid_hgt?(entry) and
        valid_hcl?(entry) and
        valid_ecl?(entry) and
        valid_pid?(entry)
      end)
    end

    # Aoc2020.Day4.task2
    def task2() do
      passportdata = "./lib/day4/input.txt" |> read
      Enum.count(passportdata, fn entry ->
        has_all_obligatory_keys?(entry) and
        valid_byr?(entry) and
        valid_iyr?(entry) and
        valid_eyr?(entry) and
        valid_hgt?(entry) and
        valid_hcl?(entry) and
        valid_ecl?(entry) and
        valid_pid?(entry)
      end)
    end
end
