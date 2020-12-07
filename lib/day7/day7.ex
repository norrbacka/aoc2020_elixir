defmodule Aoc2020.Day7 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn entry ->
      bags = entry |> String.split(" contain ")
      color = Enum.at(bags, 0) |> String.replace("bags", "") |> String.trim()

      children =
        Enum.at(bags, 1)
        |> String.replace(".", "")
        |> String.split(", ")
        |> Enum.map(fn child ->
          cond do
            child |> String.contains?("no other bags") ->
              []
            true ->
              {amount, _} =
                child |> String.slice(0..0) |> String.to_charlist() |> :string.to_integer()

              name = child |> String.slice(1, String.length(child))

              color =
                name
                |> String.replace("bags", "")
                |> String.replace("bag", "")
                |> String.trim()

              %{
                amount: amount,
                color: color
              }
          end
        end)
        |> Enum.filter(fn child -> child != [] end) #So goddamn ugly, but whatever
      %{
        :color => color,
        :children => children
      }
    end)
  end

  def get_parents_for_color(bags, color, colors) do
    colors = Enum.concat(colors, [color])
    parents =
      bags
      |> Enum.filter(fn
        bag -> Enum.any?(bag.children, fn x -> x.color == color end)
      end)
    case Enum.any?(parents) do
      is_parent when is_parent == true ->
        colors
        |> Enum.concat(
          Enum.flat_map(parents, fn p ->
            get_parents_for_color(bags, p.color, colors)
          end)
        )
      is_parent when is_parent == false ->
        colors
    end
  end

  # Aoc2020.Day7.task1
  def task1 do
    ("./lib/day7/input.txt"
     |> read
     |> get_parents_for_color("shiny gold", [])
     |> Enum.uniq()
     |> Enum.count()) - 1 # because we include ourself at the moment, so we have to retract that
  end

  def get_children_for_color(bags, color) do
    current =
      bags
      |> Enum.find(fn bag -> bag.color == color end)

    current.children
    |> Enum.flat_map(fn child ->
      cond do
        child != [] ->
          1..child.amount
          |> Enum.flat_map(fn _ ->
            [child.color, get_children_for_color(bags, child.color)]
          end)

        true ->
          []
      end
    end)
  end

  # Aoc2020.Day7.task2
  def task2 do
    "./lib/day7/input.txt"
    |> read
    |> get_children_for_color("shiny gold")
    |> List.flatten()
    |> Enum.count()
  end
end
