defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def parse_key(line) do
    # "AAA = (BBB, CCC)" to ["AAA", "BBB", "CCC"]
    line
    |> String.split("=")
    |> List.first()
    |> String.trim()
  end

  def parse_value(line) do
    value = line
    |> String.split("=")
    |> List.last()
    |> String.trim()
    |> String.replace("(", "")
    |> String.replace(")", "")
    |> String.split(",")
    |> Enum.map(fn x -> String.trim(x) end)
  end

  def parse_lines(lines) do
    lines
    |> Enum.map(fn x -> {parse_key(x), parse_value(x)} end)
    |> Map.new()
  end

  def next(instr, idx, mapp, pos, cur) do
    if pos == "ZZZ" do
      cur
    else
      len = instr |> String.length
      idx_cycle = idx |> Integer.mod(len)
      case String.at(instr, idx_cycle) do
        "L" ->
          next(instr, idx+1, mapp, mapp |> Map.get(pos) |> Enum.at(0), cur+1)
        "R" ->
          next(instr, idx+1, mapp, mapp |> Map.get(pos) |> Enum.at(1), cur+1)
      end
    end
  end
end

instructions = "LLRLLRLRLRRRLLRRRLRRLRLRLRLRLRLRRLRRRLRLLRRLRRLRRRLLRLLRRLLRRRLLLRLRRRLLLLRRRLLRRRLRRLRLLRLRLRRRLRRRLRRLRRLRRLRLLRRRLRRLRRRLLRRRLRLRRLLRRLLRLRLRRLRRLLRLLRRLRLLRRRLLRRRLRRLLRRLRRRLRLRRRLRRLLLRLLRLLRRRLRLRLRLRRLRRRLLLRRRLRRRLRRRLRRLRLRLRLRRRLRRLLRLRRRLRLRLRRLLLRRRR"

lines = Solution.readLines()
mapp = Solution.parse_lines(lines)

ans = Solution.next(instructions, 0, mapp, "AAA", 0)

ans |> IO.inspect()
