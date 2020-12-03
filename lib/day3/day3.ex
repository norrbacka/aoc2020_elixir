defmodule Aoc2020.Day3 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
  end

  def traverse(x, y, world, dx, dy, xs, os) do
    modulusWidth = Enum.count(Enum.at(world, 0))
    endOfWorld = Enum.count(world) - 1

    cond do
      y == endOfWorld ->
        %{:x => x, :y => y, :xs => xs, :os => os}

      true ->
        x = rem(x + dx, modulusWidth)
        y = y + dy
        c = world |> Enum.at(y) |> Enum.at(x)

        IO.inspect(%{:c => c, :xy => [x, y]})

        cond do
          c == "#" ->
            xs = xs + 1
            traverse(x, y, world, dx, dy, xs, os)

          c == "." ->
            os = os + 1
            traverse(x, y, world, dx, dy, xs, os)
        end
    end
  end

  # Aoc2020.Day3.test
  def test() do
    world = "./lib/day3/test.txt" |> read
    traverse(0, 0, world, 3, 1, 0, 0)
  end

  # Aoc2020.Day3.task1
  def task1() do
    world = "./lib/day3/input.txt" |> read
    traverse(0, 0, world, 3, 1, 0, 0)
  end
end
