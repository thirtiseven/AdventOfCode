defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.chunk_by(fn x -> x == "" end)
    |> Enum.filter(fn x -> x != [""] end)
  end

  def diff(a, b) do
    len = String.length(a)
    0..(len - 1)
    |> Enum.map(fn x -> String.at(a, x) == String.at(b, x) end)
    |> Enum.count(fn x -> x == false end)
  end

  def almost_palindrome_at(str, pos) do
    len = str |> String.length()
    half_len = min(pos + 1, len - pos - 1)
    a = String.slice(str, (pos - half_len + 1)..(pos)) |> String.reverse()
    b = String.slice(str, (pos + 1)..(pos + half_len))
    diff(a, b)
  end

  def palindrome_row_at(lines, pos) do
    diff = lines
    |> Enum.map(fn x -> almost_palindrome_at(x, pos) end)
    |> IO.inspect()
    |> Enum.sum()

    diff == 1
  end

  def palindrome_col_at(lines, pos) do
    len = lines |> length()
    half_len = min(pos + 1, len - pos - 1)
    a = Enum.slice(lines, (pos - half_len + 1)..(pos)) |> Enum.reverse()
    b = Enum.slice(lines, (pos + 1)..(pos + half_len))
    diff = a
    |> Enum.zip(b)
    |> Enum.map(fn {x, y} -> diff(x, y) end)
    |> Enum.sum()

    diff == 1
  end

  def gao(lines) do
    lines |> IO.inspect()

    row = lines |> Enum.at(0) |> String.length()
    col = lines |> length()
    row_ans = 0..(row - 2)
    |> Enum.map(fn x -> palindrome_row_at(lines, x) end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == true end)
    |> Enum.map(fn {_, idx} -> idx+1 end)
    |> Enum.sum()
    |> IO.inspect()

    col_ans = 0..(col - 2)
    |> Enum.map(fn x -> palindrome_col_at(lines, x) end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == true end)
    |> Enum.map(fn {_, idx} -> (idx+1) * 100 end)
    |> Enum.sum()
    |> IO.inspect()

    row_ans + col_ans

  end
end

Solution.readLines()
|> Enum.map(fn x -> Solution.gao(x) end)
|> Enum.sum()
|> IO.inspect()
