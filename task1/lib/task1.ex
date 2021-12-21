defmodule Task1 do
  def get_numbers_from(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line)
  end

  @spec count_increments(charlist()) :: number()
  def count_increments(filename) do
    [first | rest] = get_numbers_from(filename) |> Enum.map(&Integer.parse/1) |> Enum.to_list()

    [_prev, counter] =
      [[first, 0] | rest]
      |> Enum.reduce(fn
        x, [prev, counter] when x > prev -> [x, counter + 1]
        x, [_prev, counter] -> [x, counter]
      end)

    counter
  end
end
