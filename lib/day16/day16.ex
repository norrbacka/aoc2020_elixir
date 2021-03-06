defmodule Aoc2020.Day16 do

  def get_tickets do
    input = "./lib/day16/input.txt" |> File.read!()
    [r, m, n] = input |> String.split("\r\n\r\n")

    rules = r
    |> String.split("\r\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn r ->
      [name, range] = String.split(r, ":")
      [range1, range2] = String.split(range, " or ")
      [range1_start, range1_end] = String.split(range1, "-") |> Enum.map(&String.trim/1)
      [range2_start, range2_end] = String.split(range2, "-") |> Enum.map(&String.trim/1)
      %{
        name: name,
        r1: (String.to_integer(range1_start)..String.to_integer(range1_end)) |> Enum.to_list,
        r2: (String.to_integer(range2_start)..String.to_integer(range2_end)) |> Enum.to_list
      }
    end)
    |> IO.inspect(label: "rule")

    tickets_nearby = n
    |> String.split("\r\n")
    |> Enum.drop(1)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn t ->
      t
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> IO.inspect(label: "tickets_nearby")

    ranges = rules
    |> Enum.map(fn rule ->
      rule.r1 ++ rule.r2
    end)

    invalid_tickets = tickets_nearby
    |> Enum.flat_map(fn t ->
      Enum.reject(t, fn ticket ->
        Enum.any?(ranges, fn range ->
          ticket in range
        end)
      end)
    end)
    |> IO.inspect(label: "invalid_tickets")

    valid_tickets = tickets_nearby
    |> Enum.filter(fn t ->
      t not in invalid_tickets
    end)

    mine = m
    |> String.split("\r\n")
    |> Enum.drop(1)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn t ->
      t
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> IO.inspect(label: "mine")

    {invalid_tickets, valid_tickets, mine, rules}
  end

  # Aoc2020.Day16.task1
  def task1() do
    {invalid_tickets, _valid_tickets, _mine, _ranges} = get_tickets()
    invalid_tickets
    |> Enum.sum()
  end

  # Aoc2020.Day16.task2
  def task1() do
    {_invalid_tickets, valid_tickets, mine, ranges} = get_tickets()


  end
end
