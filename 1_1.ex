defmodule Trebuchet do
  def get_string_input do
    IO.gets("")
  end

  def last_preprocess(str) do
    str |> String.replace("threeight", "thre8")
        |> String.replace("eightwo", "eigh2")
        |> String.replace("eight", "8")
        |> String.replace("three", "3")
        |> String.replace("one", "1")
        |> String.replace("two", "2")
        |> String.replace("nine", "9")
        |> String.replace("seven", "7")
        |> String.replace("four", "4")
        |> String.replace("five", "5")
        |> String.replace("six", "6")
        |> String.to_charlist()
  end

  def first_preprocess(str) do
    str |> String.replace("threeight", "3ight")
        |> String.replace("eightwo", "8wo")
        |> String.replace("seven", "7")
        |> String.replace("nine", "9")
        |> String.replace("two", "2")
        |> String.replace("one", "1")
        |> String.replace("eight", "8")
        |> String.replace("three", "3")
        |> String.replace("four", "4")
        |> String.replace("five", "5")
        |> String.replace("six", "6")
        |> String.to_charlist()
  end

  # 56187

  def isinteger(char) do
    char >= ?0 && char <= ?9
  end

  def get_first_digit(input) do
    input |> Enum.find(&isinteger/1) |> Kernel.-(48)
  end

  def get_last_digit(input) do
    input |> Enum.reverse |> get_first_digit
  end

  def get_value(a, b) do
    IO.puts(a * 10 + b)
    a * 10 + b
  end

  def get_trebuchet_value do
    input = get_string_input
    a = input |> first_preprocess |> get_first_digit
    b = input |> last_preprocess |> get_last_digit
    get_value(a, b)
  end

  # 29, 83, 13, 24, 42, 14, and 76.

  def get_trebuchet_values_sum(times) do
    Enum.reduce(1..times, 0, fn _i, acc -> acc + get_trebuchet_value() end)
  end
end

x = Trebuchet.get_trebuchet_values_sum(1000)

IO.puts(x)
