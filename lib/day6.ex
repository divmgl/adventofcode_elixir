defmodule Challenges.Day6 do
  @input "priv/day6input.txt" |> File.read!

  def execute_instruction(_, [], _, _, lights) do
    lights
  end

  def execute_instruction(op, [head|tail], [], y_range, lights) do
    execute_instruction(op, tail, y_range, y_range, lights)
  end

  def execute_instruction(op, [x|_] = x_range, [y|tail] = y_range,
    original_y_range, lights) do
    lights = Map.put(lights, {x, y}, case op do
      :on -> true
      :off -> false
      :toggle -> !Map.get(lights, {x, y}, false) end)

    execute_instruction(op, x_range, tail, original_y_range, lights)
  end

  def execute_instruction("", list) do
    list
  end

  def execute_instruction(instruction, list) do
    {operation, operation_phonetic} =
      case instruction do
        "turn on" <> _ -> {:on, "turn on "}
        "turn off" <> _ -> {:off, "turn off "}
        "toggle" <> _ -> {:toggle, "toggle "}
      end

    [coords] =
      instruction
      |> String.split(operation_phonetic)
      |> Enum.drop(1)
      |> Enum.map(&(String.split(&1, " through ")))

    [start_coords, end_coords] =
      Enum.map(coords, fn (coord) ->
        coord
        |> String.split(",")
        |> Enum.map(&(&1 |> Integer.parse() |> elem(0)))
      end)

    execute_instruction(operation,
      Enum.at(start_coords, 0)..Enum.at(end_coords, 0) |> Enum.map(&(&1)),
      Enum.at(start_coords, 1)..Enum.at(end_coords, 1) |> Enum.map(&(&1)),
      Enum.at(start_coords, 1)..Enum.at(end_coords, 1) |> Enum.map(&(&1)),
      list)
  end

  def build_light_matrix([], list) do
    list
  end

  def build_light_matrix([head|tail], list) do
    build_light_matrix(tail, execute_instruction(head, list))
  end

  def build_light_matrix(instructions) do
    build_light_matrix(instructions, %{})
  end

  def filter_turned_on_lights(matrix) do
    matrix
    |> Enum.filter(&(elem(&1, 1)))
    |> Enum.count
  end

  def solve(string) do
    String.split(string, "\n")
      |> build_light_matrix
      |> filter_turned_on_lights
  end

  def solve, do: solve(@input)
end
