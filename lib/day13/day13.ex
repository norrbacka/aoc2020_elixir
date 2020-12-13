defmodule Aoc2020.Day13 do

  def read(inputpath) do
    rows = inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    departure = Enum.at(rows,0) |> String.to_integer()
    buses = Regex.scan(~r/\d+/, Enum.at(rows, 1))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)

    %{
      :departure => departure,
      :buses => buses
    }
  end

  def get_closest_departure_for_bus(departure, bus_id) do
    bus_id - rem(departure, bus_id)
  end

  # Aoc2020.Day13.test
  def test do
    data = "./lib/day13/test.txt"
    |> read()

    departure = data.departure
    closest = data.buses
    |> Enum.sort(fn a, b -> get_closest_departure_for_bus(departure, b) > get_closest_departure_for_bus(departure, a) end)
    |> Enum.at(0)

    closest * (closest - rem(departure, closest))
  end

  # Aoc2020.Day13.task1
  def task1 do
    data = "./lib/day13/input.txt"
    |> read()

    departure = data.departure
    closest = data.buses
    |> Enum.sort(fn a, b -> get_closest_departure_for_bus(departure, b) > get_closest_departure_for_bus(departure, a) end)
    |> Enum.at(0)

    closest * (closest - rem(departure, closest))
  end

end
