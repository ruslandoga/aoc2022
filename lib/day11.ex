defmodule Day11 do
  # https://adventofcode.com/2022/day/11

  defp input do
    File.read!("priv/day11.txt")
  end

  def example_input do
    """
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1\
    """
  end

  defp process_input(input, part) do
    input
    |> String.split("\n\n", trim: true)
    |> Map.new(fn spec ->
      [
        "Monkey " <> monkey,
        "  Starting items: " <> items,
        "  Operation: new = " <> op,
        "  Test: divisible by " <> div_by,
        "    If true: throw to monkey " <> next_if_true,
        "    If false: throw to monkey " <> next_if_false
      ] = String.split(spec, "\n", trim: true)

      monkey = monkey |> String.trim_trailing(":") |> String.to_integer()
      items = items |> String.split(", ") |> Enum.map(&String.to_integer/1)

      next_if_true = String.to_integer(next_if_true)
      next_if_false = String.to_integer(next_if_false)
      div_by = String.to_integer(div_by)

      no_worry =
        case part do
          1 -> fn x -> round(x / 3) end
          2 -> fn x -> rem(x, 2 * 13 * 3 * 17 * 19 * 7 * 11 * 5) end
        end

      test = fn old ->
        {new, _} = Code.eval_string(op, old: old)
        new = no_worry.(new)
        next = if rem(new, div_by) == 0, do: next_if_true, else: next_if_false
        {next, new}
      end

      {monkey, {test, items, _inspected = 0}}
    end)
  end

  @doc """
      iex> part1()
      81176
  """
  def part1(input \\ input()) do
    process_input(input, 1)
    |> run_rounds(20)
    |> Enum.map(fn {_, {_, _, inspected}} -> inspected end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defp run_rounds(state, left) when left > 0 do
    state = run_round(state)
    run_rounds(state, left - 1)
  end

  defp run_rounds(state, _), do: state

  defp run_round(state) do
    monkeys = state |> Map.keys() |> Enum.sort(:asc)

    Enum.reduce(monkeys, state, fn monkey, state ->
      {test, items, inspected} = m = Map.fetch!(state, monkey)
      m = m |> put_elem(1, []) |> put_elem(2, inspected + length(items))
      state = Map.put(state, monkey, m)

      Enum.reduce(items, state, fn item, state ->
        {next, item} = test.(item)

        Map.update!(state, next, fn {_, items, _} = m ->
          put_elem(m, 1, items ++ [item])
        end)
      end)
    end)
  end

  @doc """
      iex> part2()
      15310845153
  """
  def part2(input \\ input(), rounds \\ 10000) do
    process_input(input, 2)
    |> run_rounds(rounds)
    |> Enum.map(fn {_, {_, _, inspected}} -> inspected end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end
end
