defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(fn x -> String.trim(x)
                      |> String.replace("T", "a")
                      |> String.replace("J", ".")
                      |> String.replace("Q", "c")
                      |> String.replace("K", "d")
                      |> String.replace("A", "e")
                      |> String.split(" ")
                    end)
    |> Enum.to_list()
    # |> IO.inspect
  end

  # def pre_process(str) do
  #   # replace '.' with the most frequent char except '.'
  #   ch = str
  #   |> String.to_charlist()
  #   |> Enum.filter(fn x -> x != "." end)
  #   |> Enum.group_by(fn x -> x end)
  #   |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
  #   |> Enum.sort(fn {_k1, v1}, {_k2, v2} -> v1 > v2 end)
  #   |> Enum.at(0)
  #   |> Tuple.to_list
  #   |> Enum.take(1)
  #   |> List.to_string()
  #   # |> IO.inspect

  #   str
  #   |> String.replace(".", ch)

  # end

  def pre_process(str) do
    # replace '.' with the most frequent char except '.'
    ch = str
    |> String.replace(".", "")
    |> String.to_charlist()
    # |> IO.inspect
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.sort(fn {_k1, v1}, {_k2, v2} -> v1 > v2 end)
    |> Enum.at(0)

    rep = case ch do
      nil -> "."
      x -> x
      |> Tuple.to_list
      |> Enum.take(1)
      |> List.to_string()
      # |> IO.inspect
    end

    str
    |> String.replace(".", rep)

  end

  def five_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {_k, v} -> v == 5 end)
  end

  def four_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {_k, v} -> v == 4 end)
  end

  def full_house?(cards) do
    kv = cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)

    Enum.any?(kv, fn {_k, v} -> v == 3 end) && Enum.any?(kv, fn {_k, v} -> v == 2 end)
  end

  def three_of_a_kind?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {_k, v} -> v == 3 end)
  end

  def two_pairs?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.filter(fn {_k, v} -> v == 2 end)
    |> Enum.count() == 2
  end

  def one_pair?(cards) do
    cards
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.any?(fn {_k, v} -> v == 2 end)
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
    a_type = camel_type(a_cards |> pre_process())
    b_type = camel_type(b_cards |> pre_process())

    if a_type == b_type do
      a_cards < b_cards
    else
      a_type < b_type
    end
  end

end

sorted = Solution.readLines()
|> Enum.sort(fn a, b -> Solution.camel_card_cmp(a, b) end)

sorted
|> Enum.map(fn [x, _y] -> IO.inspect([x, Solution.pre_process(x)]) end)
# |> IO.inspect

1..Enum.count(sorted)
|> Enum.zip(sorted)
|> Enum.map(fn {i, x} -> i * (Enum.at(x, 1) |> String.to_integer()) end)
|> IO.inspect
|> Enum.sum()
|> IO.inspect
