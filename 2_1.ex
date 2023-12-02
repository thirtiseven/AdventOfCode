defmodule CubeConundrum do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def parseLine(line) do
    # Game 1: 8 green, 4 red, 4 blue; 1 green, 6 red, 4 blue; 7 red, 4 green, 1 blue; 2 blue, 8 red, 8 green
    game_id = line
    |> String.split(": ")
    |> List.first()
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()

    max_map = line
    |> String.split(": ")
    |> List.last()
    |> String.split("; ")
    |> Enum.map(fn x -> String.split(x, ", ") end)
    |> Enum.map(fn x -> Enum.map(x, fn y -> String.split(y, " ") |> Enum.reverse |> List.to_tuple end) end)
    |> List.flatten
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.group_by(fn x -> Enum.at(x, 0) end)
    |> Enum.map(fn {k, v} -> {k, Enum.map(v, fn x -> Enum.at(x, 1) |> String.to_integer end)} end)
    |> Enum.map(fn {k, v} -> {k, Enum.max(v)} end)
    |> Map.new

    if max_map["green"] <= 13 && max_map["red"] <= 12 && max_map["blue"] <= 14 do
      game_id
    else
      0
    end
  end
end

ans = CubeConundrum.readLines()
|> Enum.map(fn x -> CubeConundrum.parseLine(x) end)
|> Enum.sum

IO.inspect(ans)
