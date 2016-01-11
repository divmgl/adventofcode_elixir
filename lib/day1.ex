defmodule Day1 do
  @input File.read!("priv/day1input.txt")

  # No characters left, return the floor
  def travel([], _, floor) do
    floor
  end

  # Match on ")", go down one floor
  def travel([head|tail], ")", floor) do
    travel(tail, head, floor - 1)
  end

  # Match on "(", go up one floor
  def travel([head|tail], "(", floor) do
    travel(tail, head, floor + 1)
  end

  # This is the first character, start iterating
  def travel([head|tail], nil, floor \\ 0) do
    travel(tail, head, floor)
  end

  # This character did not match anything, skip it
  def travel([_|tail], char, floor) do
    travel(tail, char, floor)
  end

  def solve do
    travel(@input |> String.split(""), nil, 0)
  end
end
