defmodule Solution do
  def get_input() do
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.at(0)
    |> String.split(",")
  end

  def hash(str) do
    # get ascii, add to hash, multiply by 17, mod 256
    str
    |> String.to_charlist()
    |> Enum.reduce(0, fn (x, acc) -> (acc + x) * 17 |> rem(256) end)
  end

  def gao(input) do
    input
    |> Enum.map(fn x -> hash(x) end)
    |> Enum.sum()
  end
end

input = Solution.get_input()
ans = Solution.gao(input)
IO.inspect(ans)
