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

  def to_int(char) do
    IO.inspect(char)
    if char >= 48 && char <= 57 do
      char - 48
    else
      -1
    end
  end

  def acc_to_right(ls) do
    case ls do
      [] -> []
      [h] -> [h]
      [-1, h | t] -> [-1] ++ acc_to_right([h | t])
      [h, -1 | t] -> [h] ++ acc_to_right([-1 | t])
      [h1, h2 | t] -> [h1] ++ acc_to_right([h1 * 10 + h2 | t])
    end
  end

  def push_to_right(ls) do
    case ls do
      [] -> []
      [h] -> [h]
      [-1, h | t] -> [-1] ++ push_to_right([h | t])
      [h, -1 | t] -> [h] ++ push_to_right([-1 | t])
      [h1, _h2 | t] -> [h1] ++ push_to_right([h1 | t])
    end
  end

  def parse_line(str) do
    # ...123....456.. -> [0, 0, 0, 123, 123, 123, 0, 0, 0, 0, 456, 456, 456, 0, 0]
    # first: ...123....456.. -> [-1, -1, -1, 1, 2, 3, -1, -1, -1, -1, 4, 5, 6, -1, -1]
    str
    |> String.to_char_list()
    |> Enum.map(&to_int/1)
    # -> [0, 0, 0, 1, 12, 123, 0, 0, 0, 0, 4, 45, 456, 0, 0]
    |> acc_to_right
    |> Enum.reverse
    |> push_to_right
    |> Enum.reverse
    # |> IO.inspect
  end

  def gear_map(map, numbers) do
    n = 140
    m = 140
    for i <- 0..n-1, j <- 0..m-1 do
      case String.at(Enum.at(map, i), j) == "*" do
        true ->
          mp = [[i - 1, j], [i - 1, j - 1], [i - 1, j + 1], [i, j - 1], [i, j + 1], [i + 1, j], [i + 1, j - 1], [i + 1, j + 1]]
          |> Enum.filter(fn [x, y] -> x >= 0 && x < n && y >= 0 && y < m end)
          |> Enum.map(fn [x, y] -> Enum.at(Enum.at(numbers, x), y) end)
          |> Enum.filter(fn x -> x > 0 end)
          |> MapSet.new

          if MapSet.size(mp) == 2 do
            MapSet.to_list(mp)
            |> Enum.product
          else
            0
          end
        false -> 0
      end
    end
    |> Enum.sum
  end

end

# Solution.parse_line("...123....459..")

map = Solution.readLines()

numbers = map |> Enum.map(&Solution.parse_line/1) |> IO.inspect

ans = Solution.gear_map(map, numbers) |> IO.inspect
