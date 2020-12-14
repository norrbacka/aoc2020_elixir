defmodule Aoc2020.Day14 do

  def to_binary_string(number) do
    :io_lib.format("~36.2.0B", [number])
    |> List.to_string()
  end

  def apply_number_on_mask(mask, number) do
    binary =
    to_binary_string(number)
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {number, index} ->
      case Enum.at(mask, index) do
        "X" -> number |> String.to_integer()
        "1" -> 1
        "0" -> 0
      end
    end)
    |> Enum.to_list()
    |> Enum.into(<<>>, fn bit -> <<bit :: 1>> end)
    <<new_number::36>> = binary
    new_number
  end

  # Aoc2020.Day14.test
  def test do
    mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X" |> String.graphemes()
    (73 == (apply_number_on_mask(mask, 11))) |> IO.inspect
    (101 == apply_number_on_mask(mask, 101)) |> IO.inspect
    (64 == apply_number_on_mask(mask, 0)) |> IO.inspect
  end

  def read(inputpath) do
    rows =
      inputpath
      |> File.read!()
      |> String.trim()
      |> String.split("mask = ")
      |> Enum.map(fn x ->
        [mask_row | data_rows] = (x |> String.split("\r\n"))
        instructions = data_rows
        |> Enum.filter(fn y -> y != "" end)
        |> Enum.map(fn y ->
          [mem | value] = String.split(y, " = ")
          mem = Regex.run(~r/\d+/, mem)
          |> Enum.at(0)
          |> String.to_integer()
          value = value
          |> Enum.at(0)
          |> String.to_integer()
          %{
            :mem => mem,
            :value => value
          }
        end)
        %{
         :mask => mask_row,
         :instructions => instructions
        }
      end)

    rows
  end

  # Aoc2020.Day14.task1
  def task1() do
    data = "./lib/day14/input.txt"
    |> read()

    memory_positions = data
    |> Enum.flat_map(fn d -> d.instructions |> Enum.map(fn i ->
      key = (i.mem |> Integer.to_string())
      key
    end) end)
    |> Enum.uniq()

    result =
    Enum.flat_map(data, fn d ->
      d.instructions
      |> Enum.map(fn i ->
        value = apply_number_on_mask(d.mask |> String.graphemes(), i.value)
        %{
          :key => i.mem |> Integer.to_string(),
          :value => value
        }
      end)
    end)
    |> Enum.reverse()

    Enum.map(memory_positions, fn m ->
      Enum.find(result, fn r -> r.key == m end).value
    end)
    |> Enum.sum()
  end
end
