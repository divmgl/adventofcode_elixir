defmodule Challenges.Day3 do
  @input "priv/day3input.txt" |> File.read!

  def solve([], _, hits) do
    Enum.count(hits)
  end

  def calc_coordinates(coords, char) do
    x_mut = y_mut = 0

    case char do
      "^" -> y_mut = 1
      "v" -> y_mut = -1
      ">" -> x_mut = 1
      "<" -> x_mut = -1
      _ -> nil
    end

    {elem(coords, 0) + x_mut, elem(coords, 1) + y_mut}
  end

  def solve([head|tail], coords, hits) do
    solve(tail, calc_coordinates(coords, head), MapSet.put(hits, coords))
  end

  def solve(string) when is_binary(string) do
    solve(String.split(string, ""), {0, 0}, MapSet.new)
  end

  def solve do
    solve(@input)
  end
end
