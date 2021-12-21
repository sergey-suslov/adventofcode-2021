defmodule Task4 do
  def get_task_initials(filename) do
    {:ok, file} = File.open(filename, [:read])
    [numbers_string | rest] = IO.stream(file, :line) |> Enum.to_list()
    [_empty | boards_strings] = rest

    numbers =
      numbers_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    boards =
      boards_strings
      |> Enum.chunk_every(5, 6)
      |> Enum.map(fn board ->
        board
        |> Enum.map(&String.trim/1)
        |> Enum.map(fn row -> Regex.replace(~r/\s+/, row, ",") end)
        |> Enum.map(fn row ->
          row
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)
      end)

    {numbers, boards}
  end

  def count_increments(filename) do
    {numbers, boards} = get_task_initials(filename)

    {sum_unmatched, last_number} =
      1..Enum.count(numbers)
      |> Enum.find_value(fn count ->
        num_slice = Enum.take(numbers, count)

        winner_game =
          boards
          |> Enum.find_value(fn board ->
            game = Game.new(board, num_slice)
            is_winner = Game.get_stats(game)
            if is_winner, do: game, else: false
          end)

        if winner_game, do: {Game.sum_unmatched(winner_game), List.last(num_slice)}, else: false
      end)

    sum_unmatched * last_number
  end

  def solve_for_game(boards, numbers, numbers_set, last_winner \\ nil)

  def solve_for_game(_boards, numbers, _numbers_set, last_winner)
      when numbers == nil do
    last_winner
  end

  def solve_for_game(boards, _numbers, _numbers_set, last_winner)
      when boards == [] do
    last_winner
  end

  def solve_for_game(boards, numbers, numbers_set, last_winner) do
    winner_games =
      boards
      |> Enum.with_index()
      |> Enum.map(fn {board, index} ->
        game = Game.new(board, numbers)
        is_winner = Game.get_stats(game)
        if is_winner, do: {game, index}, else: false
      end)
      |> Enum.filter(&(&1 != false))


    new_last_winner = List.last(winner_games)
    delete_at_indexes = Enum.map(winner_games, fn {_game, index} -> index end)

    filtered_boards =
      boards
      |> Enum.with_index()
      |> Enum.filter(fn {_v, i} -> i not in delete_at_indexes end)
      |> Enum.map(fn {v, _i} -> v end)


    new_set =
      if numbers == numbers_set, do: nil, else: Enum.take(numbers_set, Enum.count(numbers) + 1)

    solve_for_game(
      filtered_boards,
      new_set,
      numbers_set,
      (new_last_winner && elem(new_last_winner, 0)) || last_winner
    )
  end

  def part_two(filename) do
    {numbers, boards} = get_task_initials(filename)

    solution = solve_for_game(boards, Enum.take(numbers, 1), numbers)
    unmatched_summed = Game.sum_unmatched(solution)
    unmatched_summed * List.last(solution.numbers)
  end
end
