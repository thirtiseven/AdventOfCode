defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def parse_line(line) do
    line
    |> String.split(" ")
    |> Enum.map(fn x -> String.trim(x) end)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def get_diff(input_list) do
    Enum.reduce(input_list, Nil, fn (current, acc) ->
      case acc do
        Nil -> []  # Skip the first element
        _ -> acc ++ [current - Enum.at(input_list, length(acc))]
      end
    end)
  end

  def predict(list) do
    diff = get_diff(list) |> IO.inspect()
    if diff |> Enum.all?(fn x -> x == 0 end) do
      [list |> List.first()] ++ list
    else
      first = list |> List.first()
      add = predict(diff) |> List.first()
      [first - add] ++ list
    end
  end

  def gao(lines) do
    lines
    |> Enum.map(fn x -> parse_line(x) end)
    |> Enum.map(fn x -> predict(x) end)
    |> Enum.map(fn x -> List.first(x) end)
    |> Enum.sum()
  end
end

# diff = Solution.get_diff([1, 2, 3, 4, 5]) |> IO.inspect()

lines = Solution.readLines()
ans = Solution.gao(lines)
IO.inspect(ans)
