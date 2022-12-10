defmodule Day10 do
  # https://adventofcode.com/2022/day/10

  defp input do
    File.stream!("priv/day10.txt")
  end

  def example_input do
    """
    addx 15
    addx -11
    addx 6
    addx -3
    addx 5
    addx -1
    addx -8
    addx 13
    addx 4
    noop
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx -35
    addx 1
    addx 24
    addx -19
    addx 1
    addx 16
    addx -11
    noop
    noop
    addx 21
    addx -15
    noop
    noop
    addx -3
    addx 9
    addx 1
    addx -3
    addx 8
    addx 1
    addx 5
    noop
    noop
    noop
    noop
    noop
    addx -36
    noop
    addx 1
    addx 7
    noop
    noop
    noop
    addx 2
    addx 6
    noop
    noop
    noop
    noop
    noop
    addx 1
    noop
    noop
    addx 7
    addx 1
    noop
    addx -13
    addx 13
    addx 7
    noop
    addx 1
    addx -33
    noop
    noop
    noop
    addx 2
    noop
    noop
    noop
    addx 8
    noop
    addx -1
    addx 2
    addx 1
    noop
    addx 17
    addx -9
    addx 1
    addx 1
    addx -3
    addx 11
    noop
    noop
    addx 1
    noop
    addx 1
    noop
    noop
    addx -13
    addx -19
    addx 1
    addx 3
    addx 26
    addx -30
    addx 12
    addx -1
    addx 3
    addx 1
    noop
    noop
    noop
    addx -9
    addx 18
    addx 1
    addx 2
    noop
    noop
    addx 9
    noop
    noop
    noop
    addx -1
    addx 2
    addx -37
    addx 1
    addx 3
    noop
    addx 15
    addx -21
    addx 22
    addx -6
    addx 1
    noop
    addx 2
    addx 1
    noop
    addx -10
    noop
    noop
    addx 20
    addx 1
    addx 2
    addx 2
    addx -6
    addx -11
    noop
    noop
    noop\
    """
    |> String.split("\n", trim: true)
  end

  defp process_input(input) do
    input
    |> Enum.flat_map(fn line ->
      case String.trim(line) do
        "noop" -> [0]
        "addx " <> x -> [0, String.to_integer(x)]
      end
    end)
  end

  @doc """
      iex> part1()
      16880
  """
  def part1(input \\ input()) do
    {_sum, strengths} =
      process_input(input)
      |> Enum.with_index(1)
      |> Enum.reduce({1, []}, fn {op, cycle}, {sum, strengths} ->
        case cycle do
          cycle when cycle in [20, 60, 100, 140, 180, 220] ->
            {sum + op, [cycle * sum | strengths]}

          _other ->
            {sum + op, strengths}
        end
      end)

    Enum.sum(strengths)
  end

  @doc """
      iex> part2()
      ['###..#..#..##..####..##....##.###..###..',
       '...#.#.#..#..#....#.#..#....#.#..#.#..#.',
       '...#.##...#..#...#..#..#....#.###..#..#.',
       '###..#.#..####..#...####....#.#..#.###..',
       '..#..#.#..#..#.#....#..#.#..#.#..#.#.#..',
       '...#.#..#.#..#.####.#..#..##..###..#..#.']
  """
  def part2(input \\ input()) do
    {_sum, pixels} =
      process_input(input)
      |> Enum.with_index(1)
      |> Enum.reduce({1, []}, fn {op, cycle}, {sum, pixels} ->
        if sum in [rem(cycle - 1, 40), rem(cycle - 2, 40), rem(cycle, 40)] do
          {sum + op, [?# | pixels]}
        else
          {sum + op, [?. | pixels]}
        end
      end)

    pixels
    |> :lists.reverse()
    |> Enum.chunk_every(40)
  end
end
