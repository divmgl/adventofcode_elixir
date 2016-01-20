defmodule Tests.Day7 do
  use ExUnit.Case
  alias Day7
  
  @input """
  123 -> xb
  456 -> y
  xb AND y -> d
  xb OR y -> e
  xb LSHIFT 2 -> f
  y RSHIFT 2 -> g
  NOT xb -> h
  NOT y -> i
  y -> a
  123 AND y -> k
  """

  test "coalesce int" do
    assert Day7.coalesce_int("7") === 7
    assert Day7.coalesce_int("a") === "a"
  end

  test "finds operation" do
    assert Day7.token!("xb LSHIFT 2 -> f") === 
      %{op: :lshift, left: "xb", right: 2, name: "f"}
    assert Day7.token!("123 -> xb") ===
      %{op: :assignment, name: "xb", value: 123}
    assert Day7.token!("NOT xb -> h") ===
      %{op: :not, name: "h", value: "xb"}
  end

  test "splits instructions" do
    assert Day7.split_instructions(@input) |> Enum.at(0) ===
      "123 -> xb"
  end

  test "parses circuit" do
    result = Day7.parse_circuit(@input |> Day7.split_instructions) 

    assert result |> Enum.at(0) ===
      %{op: :assignment, name: "xb", value: 123}
    assert result |> Enum.at(2) ===
      %{op: :and, left: "xb", right: "y", name: "d"}
    assert result |> Enum.at(10) === nil
  end

  test "finds wire" do
    result = Day7.parse_circuit(@input |> Day7.split_instructions) 

    assert result |> Day7.signal_for("xb") === 123
    assert result |> Day7.signal_for("d") === 72
    assert result |> Day7.signal_for("h") === 65412
    assert result |> Day7.signal_for("i") === 65079
    assert result |> Day7.signal_for("g") === 114
    assert result |> Day7.signal_for("y") === 456
    assert result |> Day7.signal_for("a") === 456
    assert result |> Day7.signal_for("k") === 72
  end
end