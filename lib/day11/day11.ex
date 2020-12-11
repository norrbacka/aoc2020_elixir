defmodule Aoc2020.Day11 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn x -> x |> String.graphemes() end)
    |> Enum.to_list()
  end

  def print(rows) do
    rows
    |> Enum.each(fn row ->
      row
      |> Enum.join()
      |> IO.puts()
    end)
  end

  def equals(world1, world2) do
    flat_w1 = world1 |> List.flatten() |> Enum.join()
    flat_w2 = world2 |> List.flatten() |> Enum.join()
    flat_w1 == flat_w2
  end

  def get_adjacents(world, x, y) do
    top =
      cond do
        y > 0 -> world.map |> Enum.at(y - 1) |> Enum.at(x)
        true -> nil
      end

    top_right =
      cond do
        x < world.width and y > 0 -> world.map |> Enum.at(y - 1) |> Enum.at(x + 1)
        true -> nil
      end

    right =
      cond do
        x < world.width -> world.map |> Enum.at(y) |> Enum.at(x + 1)
        true -> nil
      end

    bottom_right =
      cond do
        x < world.width and y < world.height -> world.map |> Enum.at(y + 1) |> Enum.at(x + 1)
        true -> nil
      end

    bottom =
      cond do
        y < world.height -> world.map |> Enum.at(y + 1) |> Enum.at(x)
        true -> nil
      end

    bottom_left =
      cond do
        x > 0 and y < world.height -> world.map |> Enum.at(y + 1) |> Enum.at(x - 1)
        true -> nil
      end

    left =
      cond do
        x > 0 -> world.map |> Enum.at(y) |> Enum.at(x - 1)
        true -> nil
      end

    top_left =
      cond do
        x > 0 and y > 0 -> world.map |> Enum.at(y - 1) |> Enum.at(x - 1)
        true -> nil
      end

    [top, top_right, right, bottom_right, bottom, bottom_left, left, top_left]
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.to_list()
  end

  def next_world(world, x, y, new_world) do
    case {x, y} do
      {x, y} when x == 0 and y == world.height + 1 ->
        %{
          :map => new_world |> Enum.chunk_every(world.width + 1),
          :height => world.height,
          :width => world.width
        }

      {x, y} ->
        adjacents = get_adjacents(world, x, y)

        {next_x, next_y} =
          case x == world.width do
            true -> {0, y + 1}
            false -> {x + 1, y}
          end

        case world.map |> Enum.at(y) |> Enum.at(x) do
          # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
          "L" ->
            case adjacents |> Enum.all?(fn seat -> seat != "#" end) do
              true ->
                next_world(world, next_x, next_y, new_world ++ ["#"])

              false ->
                next_world(world, next_x, next_y, new_world ++ ["L"])
            end

          # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
          "#" ->
            case adjacents |> Enum.count(fn seat -> seat == "#" end) >= 4 do
              true ->
                next_world(world, next_x, next_y, new_world ++ ["L"])

              false ->
                next_world(world, next_x, next_y, new_world ++ ["#"])
            end

          # Otherwise, the seat's state does not change
          _ ->
            next_world(world, next_x, next_y, new_world ++ ["."])
        end
    end
  end

  def print_states_until_same_state(world, previous_world, i) do
    world.map |> print
    IO.puts("|")
    IO.puts("V")

    cond do
      previous_world == nil or
          equals(world.map, previous_world.map) == false ->
        print_states_until_same_state(next_world(world, 0, 0, []), world, i + 1)

      true ->
        {:done, %{:final_world => world}}
    end
  end

  # Aoc2020.Day11.test
  def test do
    map =
      "./lib/day11/test.txt"
      |> read()

    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    world = %{
      :map => map,
      :height => height - 1,
      :width => width - 1
    }

    {:done, x} = print_states_until_same_state(world, nil, 1)

    x.final_world.map
    |> List.flatten()
    |> Enum.count(fn x -> x == "#" end)
  end

  # Aoc2020.Day11.task1
  def task1 do
    map =
      "./lib/day11/input.txt"
      |> read()

    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    world = %{
      :map => map,
      :height => height - 1,
      :width => width - 1
    }

    {:done, x} = print_states_until_same_state(world, nil, 1)

    x.final_world.map
    |> List.flatten()
    |> Enum.count(fn x -> x == "#" end)
  end
end
