defmodule Solution do
  def are_you_winning(time, distance, hold) do
    running_time = time - hold
    running_distance = running_time * hold
    running_distance > distance
  end

  def ways_to_win(time, distance) do
    0..time
    |> Enum.map(fn x -> are_you_winning(time, distance, x) end)
    |> Enum.count(fn x -> x end)
  end

  def ways_to_win(time_distance) do
    Enum.map(time_distance, fn {x, y} -> ways_to_win(x, y) end)
  end
end

time = [35937366]
distance = [212206012011044]
time_distance = Enum.zip(time, distance)
Solution.ways_to_win(time_distance) |> IO.inspect
