defmodule Aoc2020.Day15 do
  def elf_game(numbers, break_index) do
    case Enum.count(numbers) == break_index do
      true ->
        numbers
      _ ->
        [last | rest] = Enum.reverse(numbers)
        last_occurence_index =
        rest
        |> Enum.with_index()
        |> Enum.find(fn {x, _} -> x == last end)
        case last_occurence_index do
          nil ->
            elf_game(numbers ++ [0], break_index)
          {_, index} ->
            index = (index + 1)
            new_list = (numbers ++ [index])
            elf_game(new_list, break_index)
        end
    end
  end

  # Aoc2020.Day15.task1
  def task1 do
    elf_game([0,14,1,3,7,9], 2020)
    |> Enum.reverse()
    |> Enum.take(1)
  end

  # Aoc2020.Day15.task2
  def task2 do
    elf_game([0,14,1,3,7,9], 30000000)
    |> Enum.reverse()
    |> Enum.take(1)
  end

end
