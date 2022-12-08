defmodule Day8 do
  # https://adventofcode.com/2022/day/8

  defp input do
    File.stream!("priv/day8.txt")
  end

  def example_input do
    """
    30373
    25512
    65332
    33549
    35390\
    """
    |> String.split("\n", trim: true)
  end

  defp process_input(input) do
    input
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, idy} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {height, idx} -> {{idx, idy}, String.to_integer(height)} end)
    end)
    |> Map.new()
  end

  @doc """
      iex> part1()
      1845
  """
  def part1(input \\ input()) do
    tree = process_input(input)
    {max_x, _} = tree |> Map.keys() |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = tree |> Map.keys() |> Enum.max_by(fn {_, y} -> y end)

    Enum.sum(
      for x <- 0..max_x, y <- 0..max_y do
        height = tree[{x, y}]

        if x == 0 or x == max_x or y == 0 or y == max_y do
          1
        else
          if visible?(x, y, height, tree, max_x, max_y) do
            1
          else
            0
          end
        end
      end
    )
  end

  defp visible?(x, y, height, tree, max_x, max_y) do
    Enum.all?(0..(x - 1), fn xx -> tree[{xx, y}] < height end) or
      Enum.all?((x + 1)..max_x, fn xx -> tree[{xx, y}] < height end) or
      Enum.all?(0..(y - 1), fn yy -> tree[{x, yy}] < height end) or
      Enum.all?((y + 1)..max_y, fn yy -> tree[{x, yy}] < height end)
  end

  @doc """
      iex> part2()
      230112
  """
  def part2(input \\ input()) do
    tree = process_input(input)
    {max_x, _} = tree |> Map.keys() |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = tree |> Map.keys() |> Enum.max_by(fn {_, y} -> y end)

    Enum.max(
      for x <- 0..max_x, y <- 0..max_y do
        height = tree[{x, y}]

        if x == 0 or x == max_x or y == 0 or y == max_y do
          0
        else
          scenic_score(x, y, height, tree, max_x, max_y)
        end
      end
    )
  end

  defp scenic_score(x, y, height, tree, max_x, max_y) do
    a =
      Enum.reduce_while((x - 1)..0, 0, fn xx, count ->
        if tree[{xx, y}] < height do
          {:cont, count + 1}
        else
          {:halt, count + 1}
        end
      end)

    b =
      Enum.reduce_while((x + 1)..max_x, 0, fn xx, count ->
        if tree[{xx, y}] < height do
          {:cont, count + 1}
        else
          {:halt, count + 1}
        end
      end)

    c =
      Enum.reduce_while((y - 1)..0, 0, fn yy, count ->
        if tree[{x, yy}] < height do
          {:cont, count + 1}
        else
          {:halt, count + 1}
        end
      end)

    d =
      Enum.reduce_while((y + 1)..max_y, 0, fn yy, count ->
        if tree[{x, yy}] < height do
          {:cont, count + 1}
        else
          {:halt, count + 1}
        end
      end)

    a * b * c * d
  end
end
