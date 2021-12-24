defmodule Task4Test do
  use ExUnit.Case
  doctest Task5

  test "calc small file" do
    assert Task5.part1("test/small.txt") == 12
  end

 test "calc default file" do
   assert Task5.part1("test/default.txt") == 17882
 end
end
