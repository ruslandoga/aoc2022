defmodule Day7 do
  # https://adventofcode.com/2022/day/7

  defp input do
    File.stream!("priv/day7.txt")
  end

  defp process_input(input) do
    Enum.map(input, &String.trim/1)
  end

  @doc """
      iex> part1()
      2031851
  """
  def part1(input \\ input()) do
    input
    |> process_input()
    |> build_tree(_cwd = [], _acc = %{})
    |> Enum.into([])
    |> calc_part1(_acc = %{})
    |> Enum.filter(fn {_, s} -> s <= 100_000 end)
    |> Enum.map(fn {_, s} -> s end)
    |> Enum.sum()
  end

  defp build_tree(["$ cd /" | rest], _cwd, acc), do: build_tree(rest, [], acc)

  defp build_tree(["$ cd .." | rest], cwd, acc),
    do: build_tree(rest, List.delete_at(cwd, -1), acc)

  defp build_tree(["$ cd " <> dir | rest], cwd, acc), do: build_tree(rest, cwd ++ [dir], acc)
  defp build_tree(["$ ls" | rest], cwd, acc), do: collect_ls(rest, cwd, acc)
  defp build_tree([], _csv, acc), do: acc

  defp collect_ls(["$" <> _ | _] = rest, cwd, acc), do: build_tree(rest, cwd, acc)
  defp collect_ls(["dir " <> _ | rest], cwd, acc), do: collect_ls(rest, cwd, acc)

  defp collect_ls([file | rest], cwd, acc) do
    [size, name] = String.split(file)
    collect_ls(rest, cwd, Map.put(acc, cwd ++ [name], String.to_integer(size)))
  end

  defp collect_ls([], _cwd, acc), do: acc

  defp calc_part1([{path, size} | rest], acc) do
    path = List.delete_at(path, -1)
    acc = update_acc_part1(path, size, acc)
    calc_part1(rest, acc)
  end

  defp calc_part1([], acc) do
    acc
  end

  defp update_acc_part1([], size, acc), do: Map.update(acc, [], size, fn prev -> prev + size end)

  defp update_acc_part1(path, size, acc) do
    acc = Map.update(acc, path, size, fn prev -> prev + size end)
    update_acc_part1(List.delete_at(path, -1), size, acc)
  end

  @doc """
      iex> part2()
      2568781
  """
  def part2(input \\ input()) do
    tree =
      input
      |> process_input()
      |> build_tree(_cwd = [], _acc = %{})

    used = tree |> Enum.map(fn {_, s} -> s end) |> Enum.sum()
    free = 70_000_000 - used
    to_free = 30_000_000 - free

    {_, size} =
      tree
      |> Enum.into([])
      |> calc_part1(_acc = %{})
      |> Enum.filter(fn {_, s} -> s >= to_free end)
      |> Enum.sort_by(fn {_, s} -> s end, :asc)
      |> List.first()

    size
  end
end
