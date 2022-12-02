defmodule Day2 do
  # https://adventofcode.com/2022/day/2

  defp input1 do
    File.stream!("priv/day2.txt")
    |> Enum.map(fn row ->
      [other, me] = row |> String.trim() |> String.split()
      [map_other(other), map_me(me)]
    end)
  end

  defp map_other("A"), do: :rock
  defp map_other("B"), do: :paper
  defp map_other("C"), do: :scissors

  defp map_me("X"), do: :rock
  defp map_me("Y"), do: :paper
  defp map_me("Z"), do: :scissors

  @doc """
      iex> part1()
      13052
  """
  def part1 do
    calc_score(input1())
  end

  defp calc_score([[other, me] | rest]) do
    game_score(other, me) + pick_score(me) + calc_score(rest)
  end

  defp calc_score([]), do: 0

  defp pick_score(:rock), do: 1
  defp pick_score(:paper), do: 2
  defp pick_score(:scissors), do: 3

  defp game_score(:rock, :paper), do: _win = 6
  defp game_score(:rock, :rock), do: _tie = 3
  defp game_score(:rock, :scissors), do: _loss = 0
  defp game_score(:paper, :paper), do: 3
  defp game_score(:paper, :rock), do: 0
  defp game_score(:paper, :scissors), do: 6
  defp game_score(:scissors, :paper), do: 0
  defp game_score(:scissors, :rock), do: 6
  defp game_score(:scissors, :scissors), do: 3

  defp input2 do
    File.stream!("priv/day2.txt")
    |> Enum.map(fn row ->
      [other, me] = row |> String.trim() |> String.split()
      other = map_other(other)
      [other, map_me(me, other)]
    end)
  end

  defp map_me("Y", pick), do: pick
  defp map_me("X", :rock), do: :scissors
  defp map_me("Z", :rock), do: :paper
  defp map_me("X", :paper), do: :rock
  defp map_me("Z", :paper), do: :scissors
  defp map_me("X", :scissors), do: :paper
  defp map_me("Z", :scissors), do: :rock

  @doc """
      iex> part2()
      13693
  """
  def part2 do
    calc_score(input2())
  end
end
