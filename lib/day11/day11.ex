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
    column_count =
      rows
      |> Enum.at(0)
      |> Enum.with_index()
      |> Enum.map(fn {_, index} -> index end)
      |> Enum.join()

    IO.puts("  #{column_count}")

    rows
    |> Enum.with_index()
    |> Enum.each(fn {row, index} ->
      IO.puts("#{index} #{row |> Enum.join()}")
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

  def take_until_blocked(list) do
    take_until_blocked(list, [])
  end

  def take_until_blocked(list, result) do
    cond do
      Enum.count(list) <= 1 ->
        case result do
          [] -> list
          _ -> result ++ list
        end

      true ->
        [c | rest] = list

        case c do
          "." -> take_until_blocked(rest, result ++ [c])
          _ -> result ++ [c]
        end
    end
  end

  def get_adjacents_until_blocked(world, x, y) do
    top =
      for(
        dy <- (y - 1)..0,
        dy >= 0,
        y > 0,
        do:
          [dy]
          |> Enum.map(fn dy -> world.map |> Enum.at(dy) |> Enum.at(x) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    top_right =
      for(
        dx <- (x + 1)..world.width,
        y - (dx - x) >= 0,
        dx <= world.width,
        x < world.width,
        do:
          [%{:dx => dx, :dy => y - (dx - x)}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    right =
      for(
        dx <- (x + 1)..world.width,
        y >= 0,
        dx <= world.width,
        x < world.width,
        do:
          [%{:dx => dx, :dy => y}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    bottom_right =
      for(
        dx <- (x + 1)..world.width,
        y + (dx - x) <= world.height,
        dx <= world.width,
        x < world.width,
        do:
          [%{:dx => dx, :dy => y + (dx - x)}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    bottom =
      for(
        dy <- (y + 1)..world.height,
        dy <= world.height,
        y < world.height,
        do:
          [dy]
          |> Enum.map(fn dy -> world.map |> Enum.at(dy) |> Enum.at(x) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    bottom_left =
      for(
        dx <- (x - 1)..0,
        y + (x - dx) <= world.height,
        dx >= 0,
        x > 0,
        do:
          [%{:dx => dx, :dy => y + (x - dx)}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    left =
      for(
        dx <- (x - 1)..0,
        dx >= 0,
        x > 0,
        do:
          [%{:dx => dx, :dy => y}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    top_left =
      for(
        dx <- (x - 1)..0,
        y - (x - dx) >= 0,
        dx >= 0,
        x > 0,
        do:
          [%{:dx => dx, :dy => y - (x - dx)}]
          |> Enum.map(fn x -> world.map |> Enum.at(x.dy) |> Enum.at(x.dx) end)
      )
      |> List.flatten()
      |> take_until_blocked()

    %{
      :top => top,
      :top_right => top_right,
      :right => right,
      :bottom_right => bottom_right,
      :bottom => bottom,
      :bottom_left => bottom_left,
      :left => left,
      :top_left => top_left,
      :x => x,
      :y => y
    }
  end

  def flat_adjacents(adj) do
    [
      adj.top,
      adj.top_right,
      adj.right,
      adj.bottom_right,
      adj.bottom,
      adj.bottom_left,
      adj.left,
      adj.top_left
    ]
    |> List.flatten()
  end

  # Aoc2020.Day11.test2_eight
  def test2_eight do
    map =
      "./lib/day11/eight_example.txt"
      |> read()

    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    world = %{
      :map => map,
      :height => height - 1,
      :width => width - 1
    }

    world.map |> print
    get_adjacents_until_blocked(world, 3, 4)
  end

  # Aoc2020.Day11.test_one_empty_seat
  def test_one_empty_seat do
    map =
      "./lib/day11/one_empty_seat.txt"
      |> read()

    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    world = %{
      :map => map,
      :height => height - 1,
      :width => width - 1
    }

    world.map |> print
    get_adjacents_until_blocked(world, 1, 1)
  end

  # Aoc2020.Day11.test_no_seats
  def test_no_seats do
    map =
      "./lib/day11/no_seats.txt"
      |> read()

    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    world = %{
      :map => map,
      :height => height - 1,
      :width => width - 1
    }

    world.map |> print
    get_adjacents_until_blocked(world, 3, 3)
  end

  def next_world_2(world, x, y, new_world) do
    case {x, y} do
      {x, y} when x == 0 and y == world.height + 1 ->
        %{
          :map => new_world |> Enum.chunk_every(world.width + 1),
          :height => world.height,
          :width => world.width
        }

      {x, y} ->
        adjacents =
          get_adjacents_until_blocked(world, x, y)
          |> flat_adjacents()

        {next_x, next_y} =
          case x == world.width do
            true -> {0, y + 1}
            false -> {x + 1, y}
          end

        case world.map |> Enum.at(y) |> Enum.at(x) do
          # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
          # CORRECTION
          # empty seats that see no occupied seats become occupied
          "L" ->
            case adjacents |> Enum.all?(fn seat -> seat != "#" end) do
              true ->
                next_world_2(world, next_x, next_y, new_world ++ ["#"])

              false ->
                next_world_2(world, next_x, next_y, new_world ++ ["L"])
            end

          # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
          # CORRECTION
          # It now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules)
          "#" ->
            case adjacents |> Enum.count(fn seat -> seat == "#" end) >= 5 do
              true ->
                next_world_2(world, next_x, next_y, new_world ++ ["L"])

              false ->
                next_world_2(world, next_x, next_y, new_world ++ ["#"])
            end

          # Otherwise, the seat's state does not change
          # CORRECTION
          # seats matching no rule don't change, and floor never changes.
          _ ->
            next_world_2(world, next_x, next_y, new_world ++ ["."])
        end
    end
  end

  def print_states_until_same_state_2(world, previous_world, i) do
    # world.map |> print
    # IO.puts("|")
    # IO.puts("V")

    cond do
      previous_world == nil or
          equals(world.map, previous_world.map) == false ->
        print_states_until_same_state_2(next_world_2(world, 0, 0, []), world, i + 1)

      true ->
        {:done, %{:final_world => world}}
    end
  end

  # Aoc2020.Day11.test2
  def test2 do
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

    {:done, x} = print_states_until_same_state_2(world, nil, 1)

    x.final_world.map
    |> List.flatten()
    |> Enum.count(fn x -> x == "#" end)
  end

  # Aoc2020.Day11.task2
  def task2 do
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

    {:done, x} = print_states_until_same_state_2(world, nil, 1)

    x.final_world.map
    |> print

    x.final_world.map
    |> List.flatten()
    |> Enum.count(fn x -> x == "#" end)
  end
end
