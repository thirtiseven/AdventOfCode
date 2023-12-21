defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def col_sum(lines) do
    len = lines |> Enum.at(0) |> String.length()
    0..(len - 1)
    |> Enum.map(fn x ->
      lines
      |> Enum.map(fn y -> String.at(y, x) end)
      |> Enum.count(fn x -> x == "#" end)
    end)
  end

  def row_sum(lines) do
    lines
    |> Enum.map(fn x ->
      x
      |> String.graphemes()
      |> Enum.count(fn x -> x == "#" end)
    end)
  end

  def all_distance(one_d_sum, cur_star, cur_ans, all_star) do
    case one_d_sum do
      [] -> 0
      [_h] -> cur_ans + (all_star - cur_star) * cur_star
      [0|t] -> all_distance(t, cur_star, cur_ans + 1000000 * (all_star - cur_star) * cur_star, all_star)
      [h|t] -> all_distance(t, cur_star + h, cur_ans + (all_star - cur_star) * cur_star, all_star)
    end
  end

end

lines = Solution.readLines()

row_sum = Solution.row_sum(lines)
col_sum = Solution.col_sum(lines)
all_sum = row_sum |> Enum.sum()

col_ans = Solution.all_distance(col_sum, 0, 0, all_sum)
row_ans = Solution.all_distance(row_sum, 0, 0, all_sum)
ans = col_ans + row_ans

IO.inspect(ans)
