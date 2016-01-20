defmodule Day7 do
  use Bitwise
  import Enum, only: [at: 2]

  @input "priv/day7.txt" |> File.read!
  @keywords [rshift: ~r/RSHIFT/,
    or: ~r/OR/, 
    not: ~r/NOT/, 
    and: ~r/AND/, 
    lshift: ~r/LSHIFT/]

  def coalesce_int(input) do
    case Integer.parse(input) do
      {num, _} -> num
      _        -> input
    end
  end

  def strip(string), do: string |> String.lstrip |> String.rstrip

  def calculate(op, left, right) do
    case op do
      :rshift -> left >>> right
      :lshift -> left <<< right
      :and    -> left &&& right
      :or     -> bor(left, right)
    end
  end

  def calculate(:not, value) do
    65535 - value
  end

  def operate(index, instruction, circuit) do
    signal_both = fn -> 
      left = signal_for(circuit, instruction.left)
      right = signal_for(circuit, instruction.right)
      calculate(instruction.op, left, right)
    end

    signal_left = fn ->
      left = signal_for(circuit, instruction.left)
      right = instruction.right
      calculate(instruction.op, left, right)
    end

    result = case instruction.op do
      :assignment -> signal_for(circuit, instruction.value)
      :not -> 
        value = signal_for(circuit, instruction.value)
        calculate(instruction.op, value)
      :and -> signal_both.()
      :or  -> signal_both.()
      _    -> signal_left.()
    end

    replacement = %{op: :assignment, name: instruction.name, value: result}

    circuit |> List.replace_at(index, replacement)
  end

  def operate(instruction, circuit) do
    index = Enum.find_index(circuit, fn(n) ->
      n == instruction
    end) |> operate(instruction, circuit) 
  end

  def signal_for(circuit, wire) do
    instruction = 
      Enum.filter(circuit, fn(x) ->
        x.name === wire
      end) |> List.first

    cond do
      is_integer(wire) -> wire
      instruction.op == :assignment && is_integer(instruction.value)
           -> instruction.value
      true -> instruction |> operate(circuit) |> signal_for(wire)
    end
  end

  def simplify([], parsed) do
    IO.puts("parsed")
    parsed
  end

  def simplify(circuit = [head|tail], parsed \\ nil) do
    simplify(tail, operate(head, parsed || circuit))
  end

  def token!(line) do
    {op, regex} =       
      Enum.find(@keywords, fn(e) ->
        String.match?(line, elem(e, 1))
      end) || {:assignment, nil}

    split_elements = unless op === :assignment do
      [Regex.source(regex), "->"]
    else 
      ["->"]
    end 

    array = line
    |> String.split(split_elements)
    |> Enum.map(&strip/1)
    |> Enum.filter(fn (x) -> x != "" end)
    
    coalesce = fn(n) ->
      element = at(array, n)
      case element do
        nil -> nil
        _   -> coalesce_int(element)
      end
    end

    case op do
      :assignment -> 
        %{op: op, value: coalesce.(0), name: coalesce.(1)}
      :not ->
        %{op: op, value: coalesce.(0), name: coalesce.(1)}
      _ -> 
        %{op: op, left: coalesce.(0), right: coalesce.(1), name: coalesce.(2)}
    end
  end

  def parse_circuit([], circuit), do: circuit

  def parse_circuit([""|tail], circuit), 
  do: parse_circuit(tail, circuit)

  def parse_circuit([head|tail], circuit \\ []),
  do: parse_circuit(tail, circuit ++ [token!(head)])  

  def split_instructions(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
  end

  def solve(input, wire) do
    input
    |> split_instructions
    |> parse_circuit
    |> simplify
    |> signal_for(wire)
  end

  def solve do
    solve(@input, "a")
  end
end