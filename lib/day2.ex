defmodule Challenges.Day2 do
  def pcalc({l, _}, {w, _}, {h, _}) do
    min = [l * w, w * h, h * l] |> Enum.min
    (2 * l * w) + (2 * w * h)  + (2 * h * l) + min
  end

  def calc([""], total) do
    total
  end

  def calc([head|tail], total) do
    [l, w, h] =
      head
      |> String.split("x")
      |> Enum.map(fn (x) -> Integer.parse(x) end)
    calc(tail, total + pcalc(l, w, h))
  end

  def calc(input) do
    String.split(input, "\n") |> calc(0)
  end

  def solve do
    "priv/day2input.txt" |> File.read! |> calc
  end
end
