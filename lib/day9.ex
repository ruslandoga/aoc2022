defmodule Day9 do
  # https://adventofcode.com/2022/day/9

  defp input do
    File.stream!("priv/day9.txt")
  end

  def example_input do
    """
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2\
    """
    |> String.split("\n", trim: true)
  end

  defp process_input(input) do
    Enum.flat_map(input, fn line ->
      case String.trim_trailing(line) do
        "R " <> steps -> List.duplicate({_dx = 1, _dy = 0}, String.to_integer(steps))
        "L " <> steps -> List.duplicate({_dx = -1, _dy = 0}, String.to_integer(steps))
        "U " <> steps -> List.duplicate({_dx = 0, _dy = 1}, String.to_integer(steps))
        "D " <> steps -> List.duplicate({_dx = 0, _dy = -1}, String.to_integer(steps))
      end
    end)
  end

  @doc """
      iex> part1()
      6197
  """
  def part1(input \\ input()) do
    process_input(input)
    |> step_through(
      _head = {0, 0},
      _tail = {0, 0},
      _visited = MapSet.new([{0, 0}])
    )
    |> MapSet.size()
  end

  defp step_through([{dx, dy} | rest], {hx, hy}, t, acc) do
    new_h = {hx + dx, hy + dy}
    new_t = step(new_h, t)
    step_through(rest, new_h, new_t, MapSet.put(acc, new_t))
  end

  defp step_through([], _head, _tail, acc), do: acc

  @doc """
      iex> part2()
      2562
  """
  def part2(input \\ input()) do
    process_input(input)
    |> step_through_many(
      _head = {0, 0},
      _tail = List.duplicate({0, 0}, 9),
      _visited = MapSet.new([{0, 0}])
    )
    |> MapSet.size()
  end

  def example_input2 do
    """
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20\
    """
    |> String.split("\n", trim: true)
  end

  defp step_through_many([{dx, dy} | rest], {hx, hy}, ts, acc) do
    new_h = {hx + dx, hy + dy}

    {t, ts} =
      Enum.reduce(ts, {new_h, []}, fn t, {h, acc} ->
        new_t = step(h, t)
        {new_t, [new_t | acc]}
      end)

    step_through_many(rest, new_h, :lists.reverse(ts), MapSet.put(acc, t))
  end

  defp step_through_many([], _h, _ts, visited), do: visited

  defp step({hx, hy}, {tx, ty} = t) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) == 2 and abs(dy) == 2 -> {tx + sign(dx), ty + sign(dy)}
      abs(dx) > 1 -> {tx + sign(dx), hy}
      abs(dy) > 1 -> {hx, ty + sign(dy)}
      true -> t
    end
  end

  defp sign(x) when x < 0, do: -1
  defp sign(_), do: 1
end
