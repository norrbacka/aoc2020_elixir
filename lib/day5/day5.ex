defmodule Aoc2020.Day5 do

  defmodule Columns do

    def get(entry) do
      entry
        |> String.slice(7..9)
        |> String.replace("R", "1")
        |> String.replace("L", "0")
        |> to_charlist()
        |> List.to_integer(2)
    end

    # Aoc2020.Day5.Columns.test
    def test do #print 7-0
      get("BBFFBBFRRR") == 7 and
      get("BBFFBBFRRL") == 6 and
      get("BBFFBBFRLR") == 5 and
      get("BBFFBBFRLL") == 4 and
      get("BBFFBBFLRR") == 3 and
      get("BBFFBBFLRL") == 2 and
      get("BBFFBBFLLR") == 1 and
      get("BBFFBBFLLL") == 0
    end

  end

  defmodule Rows do
    def get(entry) do
      entry
        |> String.slice(0..6)
        |> String.replace("F", "0")
        |> String.replace("B", "1")
        |> to_charlist()
        |> List.to_integer(2)
    end

    # Aoc2020.Day5.Rows.test
    def test do
      get("BFFFBBFRRR") == 70 and
      get("FFFBBBFRRR") == 14 and
      get("BBFFBBFRLL") == 102
    end
  end

  defmodule SetIdCalculator do
    def calc(entry) do
      row = Rows.get(entry)
      column = Columns.get(entry)
      seat_id = (row * 8) + column
      seat_id
    end

    # Aoc2020.Day5.SetIdCalculator.test
    def test do
      calc("BFFFBBFRRR") == 567 and
      calc("FFFBBBFRRR") == 119 and
      calc("BBFFBBFRLL") == 820
    end
  end

  defmodule Read do
    def get(inputpath) do
      inputpath
        |> File.read!()
        |> String.trim()
        |> String.split("\r\n")
    end
  end

  # Aoc2020.Day5.task1
  def task1 do
    input = Read.get("./lib/day5/input.txt")
    seat_ids = Enum.map(input, fn entry -> SetIdCalculator.calc(entry) end)
    highest_seat_id = Enum.max(seat_ids)
    highest_seat_id
  end

  # Aoc2020.Day5.task2
  def task2 do
    input = Read.get("./lib/day5/input.txt")
    my_seat = (Enum.map(input, fn entry -> SetIdCalculator.calc(entry) end)
      |> Enum.sort()
      |> Enum.chunk_every(2, 1)
      |> Enum.find(fn x -> Enum.at(x,0) != Enum.at(x,1) -1 end)
      |> Enum.at(0)) + 1
      my_seat
  end

end
