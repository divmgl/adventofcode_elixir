defmodule Day1 do
  @input File.read!("priv/day1.txt")

  def travel([], _, -1 = floor) do
    floor
  end

  # No characters left, return the floor
  def travel([], _, floor) do
    floor
  end

  def travel([head|tail], char, floor) do
    change = case char do
      ")" -> -1 # Match on ")", go down one floor
      "(" -> 1 # Match on "(", go up one floor
      _ -> 0
    end

    travel(tail, head, floor + change)
  end

  def solve do
    @input |> String.split("") |> travel(nil, 0)
  end
end
