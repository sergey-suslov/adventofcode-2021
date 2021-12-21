defmodule Task2 do
  def get_numbers_from(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line)
  end

  defp debugMatch(entry) do
    d = Regex.named_captures(~r/(?<direction>\w*)/, entry)
    IO.inspect(d)
    if Map.get(d, "direction") === "up", do: (IO.inspect(Regex.named_captures(~r/up (?<up>\d*)/, entry) |> Map.get("up")))
    IO.inspect("entry #{entry}")
    entry
  end

  @spec count_increments(charlist()) :: number()
  def count_increments(filename) do
    sum = get_numbers_from(filename)
    #|> Stream.map(&IO.inspect/1)
    #|> Stream.map(&debugMatch/1)
    |> Stream.map(fn entry ->
      case Regex.named_captures(~r/(?<direction>\w*)/, entry) do
        %{"direction" => "forward"} ->
          [
            Regex.named_captures(~r/forward (?<forward>\d*)/, entry)
            |> IO.inspect()
            |> Map.get("forward")
            |> Integer.parse()
            |> Kernel.then(fn {x, _} -> x end),
            0
          ]

        %{"direction" => "down"} ->
          [
            0,
            Regex.named_captures(~r/down (?<down>\d*)/, entry)
            |> IO.inspect()
            |> Map.get("down")
            |> Integer.parse()
            |> Kernel.then(fn {x, _} -> x end)
          ]

        %{"direction" => "up"} ->
          [
            0,
            Regex.named_captures(~r/up (?<up>\d*)/, entry)
            |> IO.inspect()
            |> Map.get("up")
            |> Integer.parse()
            |> Kernel.then(fn {x, _} -> -1 * x end)
          ]
      end
    end)
    |> Enum.to_list()
    |> IO.inspect()
    |> Enum.reduce(fn [x, y], [x_p, y_p] -> [x + x_p, y + y_p] end)
    |> IO.inspect()
    |> Kernel.then(fn [x, y] -> x * y end)
    |> IO.inspect()
    sum
  end
end
