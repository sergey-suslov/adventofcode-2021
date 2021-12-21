defmodule Game do
  defstruct board: [1, 'a'], numbers: []
  @type t :: %Game{board: [number()], numbers: []}

  @spec new([integer()], [integer()]) :: Game.t()
  def new(board \\ [], numbers \\ []), do: %Game{board: board, numbers: numbers}

  @spec add_row(Game.t(), [integer()]) :: Game.t()
  def add_row(game, row), do: %Game{game | board: [row | game.board]}

  defp contain?(list, target) do
    Enum.find_index(list, fn e -> e == target end) !== nil
  end

  defp get_game_matches(board, numbers) do
    board
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {col, col_index} ->
        if contain?(numbers, col), do: {row_index, col_index}, else: nil
      end)
      |> Enum.filter(&(&1 != nil))
    end)
    |> Enum.flat_map(& &1)
  end

  defp get_game_status(board, matches) do
    grouped_by_row = matches |> Enum.group_by(fn {row, _col} -> row end)
    grouped_by_col = matches |> Enum.group_by(fn {_row, col} -> col end)
    [head_row | _rows] = board
    row_length = Enum.count(head_row)
    col_length = Enum.count(board)

    row_winner_index =
      grouped_by_row
      |> Map.keys()
      |> Enum.map(fn key -> {key, Enum.count(Map.get(grouped_by_row, key, []))} end)
      |> Enum.find(fn {_row, count} -> count === row_length end)

    col_winner_index =
      grouped_by_col
      |> Map.keys()
      |> Enum.map(fn key -> {key, Enum.count(Map.get(grouped_by_col, key, []))} end)
      |> Enum.find(fn {_col, count} -> count === col_length end)

    {
      row_winner_index && elem(row_winner_index, 0),
      col_winner_index && elem(col_winner_index, 1),
      row_winner_index != nil || col_winner_index != nil
    }
  end

  defp sum_unmatched(board, numbers) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn col ->
        if col not in numbers, do: col, else: 0
      end)
      |> Enum.reduce(&(&1 + &2))
    end)
    |> Enum.reduce(&(&1 + &2))
  end

  def sum_unmatched(%Game{board: board, numbers: numbers}) do
    sum_unmatched(board, numbers)
  end

  def get_stats(%Game{board: board, numbers: numbers}) do
    matches = get_game_matches(board, numbers)
    {_row, _col, is_winner} = get_game_status(board, matches)
    is_winner
  end
end
