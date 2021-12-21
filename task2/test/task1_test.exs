defmodule Task1Test do
  use ExUnit.Case
  doctest Task2

  test "calc small file" do
    assert Task2.count_increments("test/small.txt") == 150
  end

  test "calc large file" do
    assert Task2.count_increments("test/input.txt") == 1924923
  end
end
