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

        #IO.inspect(%{:c => c, :xy => [x, y]})

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

  # Aoc2020.Day3.task2
  def task2() do
    world = "./lib/day3/input.txt" |> read
    s1 = traverse(0, 0, world, 1, 1, 0, 0)
    s2 = traverse(0, 0, world, 3, 1, 0, 0)
    s3 = traverse(0, 0, world, 5, 1, 0, 0)
    s4 = traverse(0, 0, world, 7, 1, 0, 0)
    s5 = traverse(0, 0, world, 1, 2, 0, 0)
    s1.xs * s2.xs * s3.xs * s4.xs * s5.xs
  end
end
