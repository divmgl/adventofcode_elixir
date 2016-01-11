defmodule Day4 do
  @input "yzbqklnj"

  def solve("00000" <> _, count) do
    count
  end

  def solve(_, count) do
    solve(count + 1)
  end

  def solve(count) do
    hash = :md5
           |> :crypto.hash(@input <> Integer.to_string(count))
           |> Base.encode16

    solve(hash, count)
  end

  def solve do
    solve(0)
  end
end
