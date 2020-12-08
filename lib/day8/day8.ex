defmodule Aoc0202.Day8 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn row ->
      row_data = String.split(row, " ")

      %{
        :ins => row_data |> Enum.at(0),
        :value => row_data |> Enum.at(1) |> String.to_integer()
      }
    end)
  end

  @spec run_program(any, atom | %{calls: any, operation: integer}) ::



          {:error, atom | %{calls: any, operation: integer}}
          | {:ok, %{accelerator: any, calls: maybe_improper_list, operation: number}}
  def run_program(instructions, memory) do
    should_break = Enum.any?(memory.calls, fn c -> c == memory.operation end)
    total_instructions = Enum.count(instructions) - 1
    all_calls_are_made = memory.operation == total_instructions

    case instructions |> Enum.at(memory.operation) do
      nil ->
        {:error, memory}

      _ when should_break ->
        {:error, memory}

      x when x.ins == "nop" ->
        state = %{
          :operation => memory.operation + 1,
          :calls => Enum.concat(memory.calls, [memory.operation]),
          :accelerator => memory.accelerator
        }

        cond do
          all_calls_are_made -> {:ok, state}
          true -> run_program(instructions, state)
        end

      x when x.ins == "jmp" ->
        state = %{
          :operation => memory.operation + x.value,
          :calls => Enum.concat(memory.calls, [memory.operation]),
          :accelerator => memory.accelerator
        }

        cond do
          all_calls_are_made -> {:ok, state}
          true -> run_program(instructions, state)
        end

      x when x.ins == "acc" ->
        state = %{
          :operation => memory.operation + 1,
          :calls => Enum.concat(memory.calls, [memory.operation]),
          :accelerator => memory.accelerator + x.value
        }

        cond do
          all_calls_are_made -> {:ok, state}
          true -> run_program(instructions, state)
        end
    end
  end

  # Aoc0202.Day8.test
  def test() do
    {:error, end_state} =
      "./lib/day8/test.txt"
      |> read
      |> run_program(%{:operation => 0, :calls => [], :accelerator => 0})

    end_state.accelerator
  end

  # Aoc0202.Day8.task1
  def task1() do
    {:error, end_state} =
      "./lib/day8/input.txt"
      |> read
      |> run_program(%{:operation => 0, :calls => [], :accelerator => 0})

    end_state.accelerator
  end

  def flip_instruction(i, instructions) do
    instructions
    |> Enum.with_index(0)
    |> Enum.map(fn {x, j} ->
      is_jmp = x.ins == "jmp"
      is_nop = x.ins == "nop"

      cond do
        j == i and is_jmp ->
          %{
            :ins => "nop",
            :value => x.value
          }

        j == i and is_nop ->
          %{
            :ins => "jmp",
            :value => x.value
          }

        true ->
          x
      end
    end)
  end

  def run_all_combination_fixes_until_ok(input) do
    instructions = input |> read
    total_instructions = Enum.count(instructions) - 1
    all_instructions = 0..total_instructions

    all_possible_changed_instructions =
      all_instructions
      |> Enum.map(fn to_switch ->
        to_switch |> flip_instruction(instructions)
      end)

    correct_instruction =
      all_possible_changed_instructions
      |> Enum.find(fn ins ->
        case ins |> run_program(%{:operation => 0, :calls => [], :accelerator => 0}) do
          {:ok, _} ->
            true

          _ ->
            false
        end
      end)

    {:ok, end_state} =
      run_program(correct_instruction, %{:operation => 0, :calls => [], :accelerator => 0})

    end_state
  end

  # Aoc0202.Day8.test2
  def test2() do
    run_all_combination_fixes_until_ok("./lib/day8/test.txt")
  end

  # Aoc0202.Day8.task2
  def task2() do
    run_all_combination_fixes_until_ok("./lib/day8/input.txt")
  end
end
