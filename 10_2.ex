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

  def go(i, j, mapp, step) do
    # {i, j} |> IO.inspect()
    # Map.get(step, {i, j}) |> IO.inspect()
    steppp = if Map.get(step, {i, j}) == nil do
      stepp = Map.put(step, {i, j}, 1)
      dfs(i, j, mapp, stepp)
    else
      step
    end
    steppp
  end

  def dfs(i, j, mapp, step) do
    symbol = mapp |> Map.get({i, j})
    # {i, j} |> IO.inspect()
    # cur = step |> Map.get({i, j})
    step = cond do
      symbol == "|" ->
        step = go(i+1, j, mapp, step)
        step = go(i-1, j, mapp, step)
        step
      symbol == "-" ->
        step = go(i, j+1, mapp, step)
        step = go(i, j-1, mapp, step)
        step
      symbol == "F" ->
        step = go(i+1, j, mapp, step)
        step = go(i, j+1, mapp, step)
        step
      symbol == "7" ->
        step = go(i+1, j, mapp, step)
        step = go(i, j-1, mapp, step)
        step
      symbol == "J" ->
        step = go(i-1, j, mapp, step)
        step = go(i, j-1, mapp, step)
        step
      symbol == "L" ->
        step = go(i-1, j, mapp, step)
        step = go(i, j+1, mapp, step)
        step
      true -> Nil
    end
    step
  end

  def delete_non_loop(mapp, step) do
    for i <- 0..140 do
      for j <- 0..140 do
        if Map.get(step, {i, j}) == nil do
          "."
        else
          mapp |> Map.get({i, j})
        end
      end
    end
  end

  def up_flag(flag) do
    case flag do
      0 -> 1
      1 -> 0
      2 -> 3
      _ -> -1
    end
  end

  def down_flag(flag) do
    case flag do
      0 -> 2
      1 -> 3
      2 -> 0
      _ -> -1
    end
  end

  # flag 0: Nil, 1: up, 2: down, 3: full
  def get_ans(ls, cur, flag) do

    {cur, flag} = if flag == 3 do
      {cur + 1, 0}
    else
      {cur, flag}
    end

    case ls do
      [] -> 0
      [h | t] ->
        case h do
          "|" -> get_ans(t, cur + 1, flag)
          "-" -> get_ans(t, cur, flag)
          "F" -> get_ans(t, cur + 1, down_flag(flag))
          "7" -> get_ans(t, cur + 1, down_flag(flag))
          "J" -> get_ans(t, cur + 1, up_flag(flag))
          "L" -> get_ans(t, cur + 1, up_flag(flag))
          "." ->
            if cur |> Integer.mod(2) == 1 do
              1 + get_ans(t, cur, flag)
            else
              get_ans(t, cur, flag)
            end
        end
    end
  end

end

mapp = Solution.readLines()

# mapp |> Map.get({22, 114}) |> IO.inspect()

step = Map.new()
|> Map.put({22, 114}, 0)

step = Solution.dfs(22, 114, mapp, step)

ls = step
|> Map.to_list()
|> Enum.sort()
# |> IO.inspect()

clean = Solution.delete_non_loop(mapp, step)
# |> IO.inspect()

clean
|> Enum.map(fn x -> Solution.get_ans(x, 0, 0) end)
|> Enum.sum()
|> IO.inspect()
