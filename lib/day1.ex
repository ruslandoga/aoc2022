defmodule Day1 do
  # https://adventofcode.com/2022/day/1

  defp input do
    File.stream!("priv/day1.txt")
    |> Enum.map(&String.trim/1)
  end

  @doc """
      iex> part1()
      65912
  """
  def part1 do
    Enum.max(agg_calories(input(), 0))
  end

  defp agg_calories(["" | rest], total), do: [total | agg_calories(rest, 0)]
  defp agg_calories([cals | rest], total), do: agg_calories(rest, total + String.to_integer(cals))
  defp agg_calories([], total), do: [total]

  @doc """
      iex> part2()
      195625
  """
  def part2 do
    agg_calories(input(), 0)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
