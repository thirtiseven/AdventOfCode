defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(fn x -> String.trim(x)
                      |> String.replace("T", "a")
                      |> String.replace("J", "b")
                      |> String.replace("Q", "c")
                      |> String.replace("K", "d")
                      |> String.replace("A", "e")
                      |> String.split(" ")
                    end)
    |> Enum.to_list()
    # |> IO.inspect
  end

  def five_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {k, v} -> v == 5 end)
  end

  def four_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {k, v} -> v == 4 end)
  end

  def full_house?(cards) do
    kv = cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)

    Enum.any?(kv, fn {k, v} -> v == 3 end) && Enum.any?(kv, fn {k, v} -> v == 2 end)
  end

  def three_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {k, v} -> v == 3 end)
  end

  def two_pairs?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.filter(fn {k, v} -> v == 2 end)
    |> Enum.count() == 2
  end

  def one_pair?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {k, v} -> v == 2 end)
  end

  def camel_type(str) do
    cond do
      five_of_a_kind?(str) -> 7
      four_of_a_kind?(str) -> 6
      full_house?(str) -> 5
      three_of_a_kind?(str) -> 4
      two_pairs?(str) -> 3
      one_pair?(str) -> 2
      true -> 1
    end
  end

  def camel_card_cmp(a, b) do
    a_cards = Enum.at(a, 0)
    b_cards = Enum.at(b, 0)
    a_type = camel_type(a_cards)
    b_type = camel_type(b_cards)

    if a_type == b_type do
      a_cards < b_cards
    else
      a_type < b_type
    end
  end

end

sorted = Solution.readLines()
|> Enum.sort(fn a, b -> Solution.camel_card_cmp(a, b) end)
|> Enum.map(fn x -> IO.inspect(x) end)
# |> IO.inspect

1..Enum.count(sorted)
|> Enum.zip(sorted)
|> Enum.map(fn {i, x} -> i * (Enum.at(x, 1) |> String.to_integer()) end)
|> IO.inspect
|> Enum.sum()
|> IO.inspect
