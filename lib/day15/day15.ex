defmodule Aoc2020.Day15 do

  @input [0,14,1,3,7,9]

  def elf_game(count, last, break_index, history) do
    case count == break_index do
      true ->
        last
      _ ->
        case Map.get(history, last, nil) do
          nil ->
            elf_game(count+1, 0, break_index, Map.put(history, last, count))
          i ->
            elf_game(count+1, (count - i), break_index, Map.put(history, last, count))
        end
    end
  end

  # Aoc2020.Day15.task1
  def task1 do
    elf_game(Enum.count(@input), List.last(@input), 2020, Map.new(Enum.with_index(@input, 1)))
  end

  # Aoc2020.Day15.task2
  def task2 do
    elf_game(Enum.count(@input), List.last(@input), 30_000_000, Map.new(Enum.with_index(@input, 1)))
  end
end
