defmodule Solution do
  def get_input() do
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.at(0)
    |> String.split(",")
  end

  def hash(str) do
    # get ascii, add to hash, multiply by 17, mod 256
    str
    |> String.to_charlist()
    |> Enum.reduce(0, fn (x, acc) -> (acc + x) * 17 |> rem(256) end)
  end

  def get_key(str) do
    cond do
      String.contains?(str, "=") -> str |> String.split("=") |> Enum.at(0)
      String.contains?(str, "-") -> str |> String.replace("-", "")
    end
  end

  def patition(input) do
    input
    |> Enum.group_by(fn x -> x |> get_key |> hash end)
  end

  def update_by_key(list, key, value) do
    # list[{key, value}], update value or append new key-value pair
    cond do
      Enum.any?(list, fn {k, _v} -> k == key end) ->
        Enum.map(list, fn {k, v} ->
        cond do
          k == key -> {k, value}
          true -> {k, v}
        end
      end)
      true -> list ++ [{key, value}]
    end
  end

  def update(acc, step) do
    cond do
      String.contains?(step, "=") ->
        [key, value] = String.split(step, "=")
        update_by_key(acc, key, value)
      String.contains?(step, "-") ->
        key = String.replace(step, "-", "")
        Enum.filter(acc, fn {k, _v} -> k != key end)
    end
  end

  def gao(box) do
    box
    |> Enum.reduce([], fn (step, acc) -> update(acc, step) end)
    |> Enum.map(fn {_k, v} -> v |> String.to_integer() end)
    |> Enum.with_index()
    |> IO.inspect()
    |> Enum.map(fn {v, i} -> v * (i + 1) end)
    |> Enum.sum()
  end

end

Solution.get_input()
|> Solution.patition()
|> IO.inspect()
|> Enum.map(fn {k, v} -> Solution.gao(v) * (k+1) end)
|> Enum.sum()
|> IO.inspect()
