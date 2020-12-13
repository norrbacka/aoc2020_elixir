defmodule Aoc2020.Day13 do
  def read(inputpath) do
    rows =
      inputpath
      |> File.read!()
      |> String.trim()
      |> String.split("\r\n")

    departure = Enum.at(rows, 0) |> String.to_integer()

    buses =
      Regex.scan(~r/\d+/, Enum.at(rows, 1))
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
    data =
      "./lib/day13/test.txt"
      |> read()

    departure = data.departure

    closest =
      data.buses
      |> Enum.sort(fn a, b ->
        get_closest_departure_for_bus(departure, b) > get_closest_departure_for_bus(departure, a)
      end)
      |> Enum.at(0)

    closest * (closest - rem(departure, closest))
  end

  # Aoc2020.Day13.task1
  def task1 do
    data =
      "./lib/day13/input.txt"
      |> read()

    departure = data.departure

    closest =
      data.buses
      |> Enum.sort(fn a, b ->
        get_closest_departure_for_bus(departure, b) > get_closest_departure_for_bus(departure, a)
      end)
      |> Enum.at(0)

    closest * (closest - rem(departure, closest))
  end

  def get_timesheet(row) do
    row
    |> String.split(",")
    |> Enum.map(fn n ->
      cond do
        Regex.match?(~r/\d+/, n) -> String.to_integer(n)
        true -> nil
      end
    end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x != nil end)
    |> List.flatten()
  end

  def read2(inputpath) do
    rows =
      inputpath
      |> File.read!()
      |> String.trim()
      |> String.split("\r\n")

    departure = Enum.at(rows, 0) |> String.to_integer()

    timesheet = Enum.at(rows, 1) |> get_timesheet()


    %{
      :departure => departure,
      :timesheet => timesheet
    }
  end

  def get_steps_offset_from_time(timesheet, time) do
    steps_offset_from_time =
      timesheet
      |> Enum.map(fn {bus_id, i} -> rem(time + i, bus_id) end)
    steps_offset_from_time
  end

  def loop_until_find_steps_all_zero(timesheet, time) do
    steps = get_steps_offset_from_time(timesheet, time) |> IO.inspect(label: "#{time}")
    case Enum.all?(steps, fn x -> x == 0 end) do
      true -> time
      _ ->
        loop_until_find_steps_all_zero(timesheet, time+1)
    end
  end

  # Aoc2020.Day13.test2
  def test2 do
    data = "./lib/day13/test.txt" |> read2() |> IO.inspect

    # should leave me zeros everywhere
    (get_steps_offset_from_time(data.timesheet, 1068781) == [0, 0, 0, 0, 0]) |> IO.inspect
    (get_steps_offset_from_time(get_timesheet("17,x,13,19"), 3417) == [0, 0, 0]) |> IO.inspect
    (get_steps_offset_from_time(get_timesheet("67,7,59,61"), 754018) == [0, 0, 0, 0 ]) |> IO.inspect
    (get_steps_offset_from_time(get_timesheet("67,x,7,59,61"), 779210) == [0, 0, 0, 0]) |> IO.inspect
    (get_steps_offset_from_time(get_timesheet("67,7,x,59,61"), 1261476) == [0, 0, 0, 0]) |> IO.inspect
    (get_steps_offset_from_time(get_timesheet("1789,37,47,1889"), 1202161486) == [0, 0, 0, 0]) |> IO.inspect

    # okay seems to work from here
    loop_until_find_steps_all_zero(data.timesheet, 1068781-5)
  end
end
