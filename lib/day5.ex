defmodule Day5 do
  @input "priv/day5input.txt" |> File.read!
  @bad_phrases ["ab", "cd", "pq", "xy"]
  @vowels ["a", "e", "i", "o", "u"]
  @max_vowel_count 3

  def bool_to_int(bool) do
    if bool, do: 1, else: 0
  end

  def filter_contains_twins(list) do
    Enum.filter(list, fn(x) ->
      twins?(x)
    end)
  end

  def twins?([]), do: false

  def twins?([head|tail]) do
    Enum.at(tail, 0) == head || twins?(tail)
  end

  def twins?(string), do: string |> String.split("") |> twins?

  def filter_no_bad_phrases(list) do
    Enum.filter(list, fn(x) ->
      !bad_phrases?(x)
    end)
  end

  def bad_phrases?(_, []), do: false

  def bad_phrases?(string, [head|tail]) do
    String.contains?(string, head) || bad_phrases?(string, tail)
  end

  def bad_phrases?(string), do: bad_phrases?(string, @bad_phrases)

  def filter_contains_vowels(list) do
    Enum.filter(list, fn(x) ->
      vowels?(x)
    end)
  end

  def vowels?(_, [], count), do: count >= @max_vowel_count

  def vowels?(phrase, [nil|tail], count) do
    vowels?(phrase, tail, count)
  end

  def vowels?(phrase, [head|tail], count) do
    vowels?(phrase, tail, count + (String.split(phrase, head) |> Enum.count) - 1)
  end

  def vowels?(phrase) do
    vowels?(phrase, @vowels, 0)
  end

  def solve(string) do
    String.split(string, "\n")
      |> filter_contains_vowels
      |> filter_contains_twins
      |> filter_no_bad_phrases
      |> Enum.count
  end

  def solve do
    solve(@input)
  end
end
