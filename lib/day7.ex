defmodule Day7 do
  use Bitwise
  @input "priv/day7.txt" |> File.read!
  
  def perform_operation(:rshift, left, right) do
    left >>> right
  end
  
  def perform_operation(:lshift, left, right) do
    left <<< right
  end
  
  def perform_operation(:or, left, right) do
    bor(left, right)
  end
  
  def perform_operation(:and, left, right) do
    left &&& right
  end
  
  def perform_operation(:not, _left, right) do
    bnot(right)
  end
  
  def perform_operation(:assign, left, _right) do
    left
  end
  
  def find(circuit, signal, false) do
    instruction = 
      Enum.filter(circuit, fn(x) ->
        elem(x, 1) == signal
      end)
      |> List.first
    
    {operation, assignment, left, right} = instruction
    
    IO.puts(
      """
      performing #{Atom.to_string(operation)} on #{assignment} using #{left}, #{right} 
      """
    )
    
    circuit = List.delete(circuit, instruction)
    
    left = find(circuit, left)
    right = find(circuit, right)
    result = perform_operation(operation, left, right)
  end
  
  def find(_, signal, true) do
    elem(Integer.parse(signal), 0)
  end
  
  def find(_, "") do
    nil
  end
  
  def find(circuit, signal) do
    find(circuit, signal, Regex.match?(~r/^[0-9]*$/, signal))
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def sanitize(string) do
    string |> String.lstrip |> String.rstrip
  end
  
  def instruction!({:assign, nil}, instruction) do
    [left, assignment] = 
      String.split(instruction, "->")
      |> Enum.map(&sanitize/1)
      
    {:assign, assignment, left, ""}
  end
  
  def instruction!({operation, regex}, instruction) do
    [left, right, assignment] = 
      String.split(instruction, [Regex.source(regex), "->"])
      |> Enum.map(&sanitize/1)
      
    {operation, assignment, left, right}
  end
  
  def operation!(signal) do
    [rshift: ~r/RSHIFT/,
     lshift: ~r/LSHIFT/,
     and: ~r/AND/,
     or: ~r/OR/,
     not: ~r/NOT/] 
    |> Enum.find(fn(e) ->
         String.match?(signal, elem(e, 1))
       end) || {:assign, nil}
  end
  
  def parse_circuit([], circuit) do
    circuit
  end
  
  def parse_circuit([head|tail], circuit) do
    instruction = operation!(head) |> instruction!(head)
    parse_circuit(tail, circuit ++ [instruction])
  end
  
  def parse_circuit(instructions), do: parse_circuit(instructions, [])
  
  def solve(string) do
    string 
    |> String.replace("\r", "")
    |> String.split("\n")
    |> parse_circuit
    |> find("a")
  end
  
  def solve, do: solve (@input)
end