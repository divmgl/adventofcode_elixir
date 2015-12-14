defmodule AdventOfCode.Day1 do
  def travel([], _, floor) do
    floor
  end

  def travel([head|tail], ")", floor) do
    travel(tail, head, floor - 1)
  end

  def travel([head|tail], "(", floor) do
    travel(tail, head, floor + 1)
  end

  def travel([head|tail], nil, floor) do
    travel(tail, head, floor)
  end

  def travel([_|tail], char, floor) do
    travel(tail, char, floor)
  end

  def travel(value) do
      travel(String.split(value, ""), nil, 0)
  end

  def solve do
    travel(File.read!("day1input.txt"))
  end
end
