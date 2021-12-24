defmodule Task5 do
  def get_task_initials(filename) do
    {:ok, file} = File.open(filename, [:read])

    IO.stream(file, :line)
    |> Enum.map(fn line -> String.split(line, [" -> ", ","], trim: true) end)
    |> Enum.map(fn cords ->
      cords |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(filename),
    do:
      get_task_initials(filename)
      |> Enum.reduce(%{}, fn
        [x, y1, x, y2], acc ->
          Enum.reduce(y1..y2, acc, fn y, grid -> Map.update(grid, {x, y}, 1, &(&1 + 1)) end)

        [x1, y, x2, y], acc ->
          Enum.reduce(x1..x2, acc, fn x, grid -> Map.update(grid, {x, y}, 1, &(&1 + 1)) end)

        [x1, y1, x2, y2], acc ->
          Enum.zip(x1..x2, y1..y2)
          |> Enum.reduce(acc, fn point, grid -> Map.update(grid, point, 1, &(&1 + 1)) end)
      end)
      |> Map.values()
      |> Enum.count(&(&1 > 1))
end
