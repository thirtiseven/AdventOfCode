defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.chunk_by(fn x -> x == "" end)
    |> Enum.filter(fn x -> x != [""] end)
  end

  def palindrome_at(str, pos) do
    len = str |> String.length()
    half_len = min(pos + 1, len |> Integer.floor_div(2))
    a = String.slice(str, (pos - half_len + 1)..(pos)) |> String.reverse()
    b = String.slice(str, (pos + 1)..(pos + half_len))
    a == b
  end

  def palindrome_row_at(lines, pos) do
    lines
    |> Enum.map(fn x -> palindrome_at(x, pos) end)
    |> IO.inspect()
    |> Enum.all?(fn x -> x == true end)
  end

  def palindrome_col_at(lines, pos) do
    len = lines |> length()
    half_len = min(pos + 1, len |> Integer.floor_div(2))
    a = Enum.slice(lines, (pos - half_len + 1)..(pos)) |> Enum.reverse()
    b = Enum.slice(lines, (pos + 1)..(pos + half_len))
    a == b
  end

  def gao(lines) do
    lines |> IO.inspect()

    row = lines |> Enum.at(0) |> String.length()
    col = lines |> length()
    row_ans = 1..(row - 2)
    |> Enum.map(fn x -> palindrome_row_at(lines, x) end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == true end)
    |> Enum.map(fn {_, idx} -> idx+2 end)
    |> Enum.sum()

    col_ans = 1..(col - 2)
    |> Enum.map(fn x -> palindrome_col_at(lines, x) end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == true end)
    |> Enum.map(fn {_, idx} -> (idx+2) * 100 end)
    |> IO.inspect()
    |> Enum.sum()

    row_ans + col_ans

  end
end

Solution.readLines()
|> Enum.map(fn x -> Solution.gao(x) end)
|> Enum.sum()
|> IO.inspect()
