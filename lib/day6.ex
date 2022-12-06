defmodule Day6 do
  # https://adventofcode.com/2022/day/6

  defp input do
    File.read!("priv/day6.txt")
    # File.stream!("priv/day6.txt")
  end

  defp process_input(input) do
    input
  end

  @doc """
      iex> part1()
      1802
  """
  def part1(input \\ input()) do
    process_input(input) |> find_marker(0)
  end

  defp find_marker(<<a, b, c, d, rest::bytes>>, counter) do
    if uniq?([a, b, c, d]) do
      counter + 4
    else
      find_marker(<<b, c, d, rest::bytes>>, counter + 1)
    end
  end

  defp uniq?(list) do
    Enum.uniq(list) == list
  end

  @doc """
      iex> part2()
      3551
  """
  def part2(input \\ input()) do
    process_input(input) |> find_message(0)
  end

  defp find_message(<<a, b, c, d, a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, rest::bytes>>, counter) do
    if uniq?([a, b, c, d, a1, b1, c1, d1, a2, b2, c2, d2, a3, b3]) do
      counter + 14
    else
      find_message(<<b, c, d, a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, rest::bytes>>, counter + 1)
    end
  end
end
