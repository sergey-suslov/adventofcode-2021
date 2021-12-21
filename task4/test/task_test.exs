defmodule Task4Test do
  use ExUnit.Case
  doctest Task4

  test "calc small file" do
    assert Task4.count_increments("test/small.txt") == 4512
  end

  test "calc small file for part two" do
    assert Task4.part_two("test/small.txt") == 1924
  end

  test "calc default file" do
    assert Task4.count_increments("test/default.txt") == 44088
  end

  test "calc default file for part two" do
    assert Task4.part_two("test/default.txt") == 23670
  end
end
