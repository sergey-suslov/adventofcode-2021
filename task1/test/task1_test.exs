defmodule Task1Test do
  use ExUnit.Case
  doctest Task1

  test "calc small file" do
    assert Task1.count_increments("test/small.txt") == 2
  end

  test "calc large file" do
    assert Task1.count_increments("test/input.txt") == 1316
  end
end
