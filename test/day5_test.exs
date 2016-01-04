defmodule Tests.Challenges.Day5 do
  use ExUnit.Case
  alias Challenges.Day5

  test "vowels" do
    assert Day5.vowels?("ugknbfddgicrmopn")
    assert Day5.vowels?("aaa")
    assert !Day5.vowels?("dvszwmarrgswjxmb")
  end

  test "twins" do
    assert !Day5.twins?("jchzalrnumimnmhp")
    assert Day5.twins?("ugknbfddgicrmopn")
    assert Day5.twins?("aaa")
  end

  test "bad phrases" do
    assert Day5.bad_phrases?("haegwjzuvuyypxyu")
  end
end
