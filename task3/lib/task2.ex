defmodule Task2 do
  def get_numbers_from(filename) do
    {:ok, file} = File.open(filename, [:read])
    IO.stream(file, :line)
  end

  @spec count_increments(charlist()) :: number()
  def count_increments(filename) do
    strings =
      get_numbers_from(filename)
      |> Enum.map(&String.trim/1)

    count = Enum.count(strings)

    gamma =
      strings
      |> Enum.map(fn s ->
        String.split(s, "", trim: true)
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(fn {v, _} -> v end)
      end)
      |> Enum.reduce(fn list, prev ->
        Enum.zip_reduce(list, prev, [], fn x, y, acc -> Enum.concat(acc, [x + y]) end)
      end)
      |> Enum.map(fn sum -> if sum < count / 2, do: 0, else: 1 end)
      |> Enum.to_list()

    epsilon = Enum.map(gamma, &if(&1 == 1, do: 0, else: 1))

    parse = fn e ->
      e
      |> Enum.join()
      |> Integer.parse(2)
      |> Kernel.then(fn {v, _} -> v end)
    end

    gamma_value = parse.(gamma)
    epsilon_value = parse.(epsilon)

    gamma_value * epsilon_value
  end
end
