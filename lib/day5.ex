defmodule Day5 do
  # https://adventofcode.com/2022/day/5

  defp input do
    File.read!("priv/day5.txt")
  end

  defp process_input(input) do
    [stack, moves] = String.split(input, "\n\n")
    [positions | _stack] = stack = stack |> String.split("\n") |> :lists.reverse()

    stack =
      stack
      |> Enum.map(&parse_stack(positions, &1))
      |> Enum.zip()
      |> Map.new(fn stack ->
        [id | stack] = stack |> Tuple.to_list() |> Enum.reject(&is_nil/1)
        {String.to_integer(id), stack}
      end)

    moves =
      moves
      |> String.split("\n")
      |> Enum.map(fn move ->
        ["move", count, "from", from, "to", to] = String.split(move)
        Enum.map([count, from, to], &String.to_integer/1)
      end)

    {stack, moves}
  end

  defp parse_stack(<<c, positions::bytes>>, <<l, stack::bytes>>) when c >= ?1 and c <= ?9 do
    item = if l == ?\s, do: nil, else: <<l>>
    [item | parse_stack(positions, stack)]
  end

  defp parse_stack(<<_, positions::bytes>>, <<_, stack::bytes>>),
    do: parse_stack(positions, stack)

  defp parse_stack(<<>>, <<>>), do: []

  @doc """
      iex> part1()
      "VJSFHWGFT"
  """
  def part1(input \\ input()) do
    {stack, moves} = process_input(input)
    moves |> make_moves_9000(stack) |> top_items()
  end

  defp make_moves_9000([[count, from_id, to_id] | moves], stack) do
    from = stack[from_id]
    to = stack[to_id]
    {from, to} = move(:lists.reverse(from), :lists.reverse(to), count)
    stack = %{stack | from_id => :lists.reverse(from), to_id => :lists.reverse(to)}
    make_moves_9000(moves, stack)
  end

  defp make_moves_9000([], stack), do: stack

  defp move([item | from], to, count) when count > 0 do
    move(from, [item | to], count - 1)
  end

  defp move(from, to, _count = 0), do: {from, to}

  defp top_items(stack) do
    stack
    |> Enum.sort_by(fn {id, _} -> id end, :asc)
    |> Enum.map(fn {_, stack} -> List.last(stack) end)
    |> Enum.join()
  end

  @doc """
      iex> part2()
      "LCTQFBVZV"
  """
  def part2(input \\ input()) do
    {stack, moves} = process_input(input)
    moves |> make_moves_9001(stack) |> top_items()
  end

  defp make_moves_9001([[count, from_id, to_id] | moves], stack) do
    from = stack[from_id]
    to = stack[to_id]
    {to_move, from} = :lists.reverse(from) |> Enum.split(count)
    to = to ++ :lists.reverse(to_move)
    stack = %{stack | from_id => :lists.reverse(from), to_id => to}
    make_moves_9001(moves, stack)
  end

  defp make_moves_9001([], stack), do: stack
end
