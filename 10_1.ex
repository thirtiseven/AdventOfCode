defmodule Solution do
  def readLines do
    raw = File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.map(fn x -> String.graphemes(x) end)

    raw
    |> Enum.with_index()
    |> Enum.flat_map(fn {inner_list, outer_index} ->
      inner_list
      |> Enum.with_index()
      # |> IO.inspect()
      |> Enum.map(fn {char, inner_index} -> {{outer_index, inner_index}, char} end)
    end)
    # |> IO.inspect()
    # |> Enum.map(fn x -> IO.inspect(x) end)
    |> Map.new()
    # |> Enum.count()
    |> Enum.to_list()
    |> Enum.sort()
    |> Map.new()
    # |> Enum.map(fn {k, v} -> IO.inspect({k, v}) end)
  end

  def go(i, j, mapp, step, cur) do
    # {i, j} |> IO.inspect()
    # Map.get(step, {i, j}) |> IO.inspect()
    if Map.get(step, {i, j}) == nil do
      step = Map.put(step, {i, j}, cur + 1)
      dfs(i, j, mapp, step)
    end
    step
  end

  def dfs(i, j, mapp, step) do
    symbol = mapp |> Map.get({i, j})
    {i, j} |> IO.inspect()
    cur = step |> Map.get({i, j}) |> IO.inspect()
    cond do
      symbol == "|" ->
        step = go(i+1, j, mapp, step, cur)
        step = go(i-1, j, mapp, step, cur)
        step
      symbol == "-" ->
        step = go(i, j+1, mapp, step, cur)
        step = go(i, j-1, mapp, step, cur)
        step
      symbol == "F" ->
        step = go(i+1, j, mapp, step, cur)
        step = go(i, j+1, mapp, step, cur)
        step
      symbol == "7" ->
        step = go(i+1, j, mapp, step, cur)
        step = go(i, j-1, mapp, step, cur)
        step
      symbol == "J" ->
        step = go(i-1, j, mapp, step, cur)
        step = go(i, j-1, mapp, step, cur)
        step
      symbol == "L" ->
        step = go(i-1, j, mapp, step, cur)
        step = go(i, j+1, mapp, step, cur)
        step
      true -> Nil
    end
  end

end

mapp = Solution.readLines()

mapp |> Map.get({22, 114}) |> IO.inspect()

step = Map.new()
|> Map.put({22, 114}, 0)

Solution.dfs(22, 114, mapp, step)
