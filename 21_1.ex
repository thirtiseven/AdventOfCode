defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def valid(lines, x, y) do
    width = Enum.at(lines, 0) |> String.length()
    height = Enum.at(lines, 0) |> String.length()
    if x < 0 or x >= width or y < 0 or y >= height do
      false
    else
      ch = lines
      |> Enum.at(x)
      |> String.at(y)

      ch != "#"
    end
  end

  def expand(lines, x, y) do
    [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
    |> Enum.filter(fn {x, y} -> valid(lines, x, y) end)
  end

  def take_step(lines, occupied) do
    occupied
    |> Enum.flat_map(fn {x, y} -> expand(lines, x, y) end)
    |> Enum.uniq()
  end

  def gao(lines) do
    occupied = [{65, 65}]
    1..64
    |> Enum.to_list()
    |> List.foldl(occupied, fn _, acc -> take_step(lines, acc) end)
    # |> IO.inspect()
    |> Enum.count()
    |> IO.inspect()
  end

end


lines = Solution.readLines()
Solution.gao(lines)
