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
    line
    |> String.split("=")
    |> List.last()
    |> String.trim()
    |> String.replace("(", "")
    |> String.replace(")", "")
    |> String.split(",")
    |> Enum.map(fn x -> String.trim(x) end)
  end

  def get_all_keys(lines) do
    lines
    |> Enum.map(fn x -> parse_key(x) end)
  end

  def parse_lines(lines) do
    lines
    |> Enum.map(fn x -> {parse_key(x), parse_value(x)} end)
    |> Map.new()
  end

  def next(instr, mapp, pos) do
    case instr do
      "L" -> mapp |> Map.get(pos) |> Enum.at(0)
      "R" -> mapp |> Map.get(pos) |> Enum.at(1)
    end
  end

  # def traverse_all(instrs, mapp, cur, idx, poss) do

  #   if poss |> Enum.any?(fn x -> x |> String.ends_with?("Z") end) do
  #     cnt = poss |> Enum.filter(fn x -> x |> String.ends_with?("Z") end) |> Enum.count()
  #     if cnt > 1 do
  #       cur |> IO.inspect()
  #       IO.inspect(poss)
  #     end
  #   end

  #   found = poss
  #   |> Enum.all?(fn x -> x |> String.ends_with?("Z") end)

  #   if found do
  #     cur
  #   else
  #     idx_cycle = idx |> Integer.mod(instrs |> String.length)
  #     new_poss = poss
  #     |> Enum.map(fn x -> next(String.at(instrs, idx_cycle), mapp, x) end)

  #     traverse(instrs, mapp, cur+1, idx+1, new_poss)
  #   end
  # end

  def traverse(instrs, mapp, cur, idx, pos) do
    if pos |> String.ends_with?("Z") do
      cur
    else
      idx_cycle = idx |> Integer.mod(instrs |> String.length)
      new_pos = next(String.at(instrs, idx_cycle), mapp, pos)
      traverse(instrs, mapp, cur+1, idx+1, new_pos)
    end
  end

  def lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end
end

instructions = "LLRLLRLRLRRRLLRRRLRRLRLRLRLRLRLRRLRRRLRLLRRLRRLRRRLLRLLRRLLRRRLLLRLRRRLLLLRRRLLRRRLRRLRLLRLRLRRRLRRRLRRLRRLRRLRLLRRRLRRLRRRLLRRRLRLRRLLRRLLRLRLRRLRRLLRLLRRLRLLRRRLLRRRLRRLLRRLRRRLRLRRRLRRLLLRLLRLLRRRLRLRLRLRRLRRRLLLRRRLRRRLRRRLRRLRLRLRLRRRLRRLLRLRRRLRLRLRRLLLRRRR"

lines = Solution.readLines()
mapp = Solution.parse_lines(lines)

start_keys = Solution.get_all_keys(lines)
|> Enum.filter(fn x -> x |> String.ends_with?("A") end)

ans = start_keys
|> Enum.map(fn x -> Solution.traverse(instructions, mapp, 0, 0, x) end)

ans |> IO.inspect()

lcm_ans = ans
|> Enum.reduce(fn x, acc -> Solution.lcm(x, acc) end)
|> IO.inspect()
