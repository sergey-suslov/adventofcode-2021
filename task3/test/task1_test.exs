defmodule Task1Test do
  use ExUnit.Case
  doctest Task2

  test "calc small file" do
    assert Task2.count_increments("test/default.txt") == 198
  end

  test "task input file" do
    assert Task2.count_increments("test/input.txt") == 3912944
  end
end
