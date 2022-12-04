defmodule Day4 do
  # https://adventofcode.com/2022/day/4

  defp input do
    File.stream!("priv/day4.txt")
  end

  defp process_input(input) do
    Stream.map(input, fn line ->
      line |> String.trim() |> String.split([",", "-"]) |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
      iex> part1()
      567
  """
  def part1(input \\ input()) do
    input
    |> process_input()
    |> Enum.count(fn [a1, a2, b1, b2] ->
      contains?(a1, a2, b1, b2) or contains?(b1, b2, a1, a2)
    end)
  end

  @compile inline: [contains?: 4]
  defp contains?(a1, a2, b1, b2) do
    a1 >= b1 and a2 <= b2
  end

  @doc """
      iex> part2()
      907
  """
  def part2(input \\ input()) do
    input
    |> process_input()
    |> Enum.count(fn [a1, a2, b1, b2] ->
      not Range.disjoint?(Range.new(a1, a2), Range.new(b1, b2))
    end)
  end
end
