defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def parse_line(str) do
    # Card   1: 84 17 45 77 11 66 94 28 71 70 | 45 51 86 83 53 58 64 30 67 96 41 89  8 17 33 50 80 84  6  2 87 72 27 63 77
    headless = str
    |> String.split(": ")
    |> List.last()

    wins = headless
    |> String.split(" | ")
    |> List.first()
    |> String.split(" ")
    |> IO.inspect
    # |> Enum.map(fn x -> String.to_integer(x) end)

    cards = headless
    |> String.split("|")
    |> List.last()
    |> String.split(" ")
    |> Enum.filter(fn x -> x != "" end)
    # |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.map(fn x -> x in wins end)
    |> Enum.map(fn x -> if x, do: 1, else: 0 end)
    |> Enum.sum()

    case cards do
      0 -> 0
      x -> Integer.pow(2, x-1)
    end
  end

end

ans = Solution.readLines()
|> Enum.map(fn x -> Solution.parse_line(x) end)
|> Enum.sum()
|> IO.inspect()
