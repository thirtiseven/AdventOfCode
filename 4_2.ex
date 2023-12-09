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
    # |> IO.inspect
    # |> Enum.map(fn x -> String.to_integer(x) end)

    headless
    |> String.split("|")
    |> List.last()
    |> String.split(" ")
    |> Enum.filter(fn x -> x != "" end)
    # |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.map(fn x -> x in wins end)
    |> Enum.map(fn x -> if x, do: 1, else: 0 end)
    |> Enum.sum()
  end

  def cards_cnt(ls, mp, ans) do
    cur = mp
    |> Map.keys()
    |> Enum.sum
    |> Kernel.+(1)

    # print ans and cur
    IO.inspect({ans, cur})

    case ls do
      [_h] -> ans + cur
      [h | t] ->
        neu_mp =  mp
        |> Enum.map(fn {k, v} -> {k, v-1} end)
        |> Enum.filter(fn {_k, v} -> v > 0 end)
        |> Map.new()

        case h do
          0 -> cards_cnt(t, neu_mp, ans + cur)
          _ -> cards_cnt(t, Map.update(neu_mp, cur, h, fn x -> x + h end), ans + cur)
        end
    end
  end

end

Solution.readLines()
|> Enum.map(fn x -> Solution.parse_line(x) end)
|> IO.inspect()
|> Solution.cards_cnt(%{0 => 0}, 0)
|> IO.inspect()
