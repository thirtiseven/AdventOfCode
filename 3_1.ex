defmodule Solution do

  @n 140
  @m 140
  # get a list of list of chars
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def is_symbol?(char) do
    char != "." && (char < "0" || char > "9")
  end

  def has_symbol_around(map) do
    # any symbol except '.' is around map[i][j]?
    for i <- 0..@n-1, j <- 0..@m-1 do
      [[i - 1, j], [i - 1, j - 1], [i - 1, j + 1], [i, j - 1], [i, j + 1], [i + 1, j], [i + 1, j - 1], [i + 1, j + 1]]
      |> Enum.filter(fn [x, y] -> x >= 0 && x < @n && y >= 0 && y < @m end)
      |> Enum.map(fn [x, y] -> String.at(Enum.at(map, x), y) end)
      |> Enum.any?(fn x -> is_symbol?(x) end)
    end
  end

  def parse_line_helper(str, i, j, cur, ans, valid, met) do
    if j == @m do
      if cur >= 0 && met do
        ans+cur
      else
        ans
      end
    else
      if String.at(str, j) >= "0" && String.at(str, j) <= "9" do
        if cur >= 0 do
          parse_line_helper(str, i, j + 1, cur * 10 + String.to_integer(String.at(str, j)), ans, valid, met or Enum.at(valid, i*@m+j))
        else
          parse_line_helper(str, i, j + 1, -1, ans, valid, met or Enum.at(valid, i*@m+j))
        end
      else
        if cur >= 0 && met do
          parse_line_helper(str, i, j + 1, 0, ans+cur, valid, false)
        else
          parse_line_helper(str, i, j + 1, 0, ans, valid, false)
        end
      end
    end
  end

  def parse_line(str, id, valid) do
    # ...123....456.. ->
    parse_line_helper(str, id, 0, 0, 0, valid, false)
  end

end

range = 0..139 |> Enum.to_list
IO.inspect(range)

map = Solution.readLines
valid = Solution.has_symbol_around(map)

map
|> Enum.zip(range)
|> Enum.map(fn {x, y} -> Solution.parse_line(x, y, valid) end)
|> Enum.sum
|> IO.inspect
