defmodule Challenges.Day6 do
  @input "priv/day6input.txt" |> File.read!

  def execute_instruction(op, start, finish, list) do

  end

  def execute_instruction(instruction, list) do
    {operation, operation_phonetic} = case instruction do
      "turn on" <> _ -> {:on, "turn on "}
      "turn off" <> _ -> {:off, "turn off "}
      "toggle" <> _ -> {:toggle, "toggle "}
    end

    [coords] =
      instruction
      |> String.split(operation_phonetic)
      |> Enum.drop(1)
      |> Enum.map(&(String.split(&1, " through ")))
      # |> Enum.map(&(Integer.parse(&1)))

    [start_coords, end_coords] = Enum.map(coords, fn (coord) ->
      coord
      |> String.split(",")
      |> Enum.map(&(&1 |> Integer.parse() |> elem(0)))
    end)

    execute_instruction(start_coords, end_coords, operation, list)
  end

  def build_light_matrix([head|tail], list) do
    build_light_matrix(tail, execute_instruction(head, list))
  end

  def build_light_matrix(instructions) do
    build_light_matrix(instructions, [])
  end

  def filter_turned_on_lights(matrix) do

  end

  def solve(string) do
    String.split(string, "\n")
      |> build_light_matrix
      |> filter_turned_on_lights
  end

  def solve, do: solve(@input)
end
