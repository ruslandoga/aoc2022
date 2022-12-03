defmodule Day3 do
  # https://adventofcode.com/2022/day/3

  defp input do
    File.stream!("priv/day3.txt")
  end

  defp process_input(input) do
    input
    |> Stream.map(fn line -> String.trim(line) end)
  end

  @doc """
      iex> part1()
      7446
  """
  def part1(input \\ input()) do
    input
    |> process_input()
    |> Stream.map(fn line ->
      size = round(byte_size(line) / 2)
      <<a::size(size)-bytes, b::bytes>> = line
      [a, b] |> find_common() |> score()
    end)
    |> Enum.sum()
  end

  defp score(common) when common >= ?a and common <= ?z, do: common - ?a + 1
  defp score(common) when common >= ?A and common <= ?Z, do: common - ?A + 27

  @doc """
      iex> part2()
      2646
  """
  def part2(input \\ input()) do
    input
    |> process_input()
    |> Stream.chunk_every(3)
    |> Stream.map(fn lines ->
      lines |> find_common() |> score()
    end)
    |> Enum.sum()
  end

  defp find_common([<<item, items::bytes>> | rest]) do
    if Enum.all?(rest, fn line -> String.contains?(line, <<item>>) end) do
      item
    else
      find_common([items | rest])
    end
  end
end
