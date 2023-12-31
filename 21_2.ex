# Solution from *A Geometric solution to advent of code 2023, day 21* :
# https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21

defmodule Solution do
  def readLines do
    # read each line from data.txt
    File.stream!("data.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def bfs_step(lines, queue, visited) do
    {x, y} = Enum.at(queue, 0)
    queue = Enum.drop(queue, 1)
    candidates = [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
    |> Enum.filter(fn {i, j} -> i >= 0 and i < 131 and j >= 0 and j < 131 end)
    |> Enum.filter(fn {i, j} -> Enum.at(lines, i) |> String.at(j) != "#" end)
    |> Enum.filter(fn {i, j} -> !Map.has_key?(visited, {i, j}) end)

    candidates_dis = visited[{x, y}] + 1
    visited = candidates
    |> Enum.reduce(visited, fn {i, j}, acc -> Map.put_new(acc, {i, j}, candidates_dis) end)
    queue = queue ++ candidates
    {queue, visited}
  end

  def bfs_helper(lines, queue, visited) do
    {queue, visited} = bfs_step(lines, queue, visited)
    if Enum.empty?(queue) do
      visited
    else
      bfs_helper(lines, queue, visited)
    end
  end

  def bfs(lines, start) do
    queue = [start]
    visited = Map.put(%{}, start, 0)
    bfs_helper(lines, queue, visited)
    |> IO.inspect()
  end

  def man_dis({x, y}) do
    # manhattan distance from (x, y) to (65, 65)
    abs(x - 65) + abs(y - 65)
  end

  def gao(lines) do
    visited = bfs(lines, {65, 65})

    even_corners = visited
    |> Enum.filter(fn {{x, y}, v} -> rem(v, 2) == 0 and v > 65 and man_dis({x, y}) > 65 end)
    |> Enum.count()

    odd_corners = visited
    |> Enum.filter(fn {{x, y}, v} -> rem(v, 2) == 1 and v > 65 and man_dis({x, y}) > 65 end)
    |> Enum.count()

    even_full = visited
    |> Map.values()
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
    |> Enum.count()

    odd_full = visited
    |> Map.values()
    |> Enum.filter(fn x -> rem(x, 2) == 1 end)
    |> Enum.count()

    n = 202300 # ((26501365 - (131 / 2)) / 131)

    ((n+1)*(n+1)) * odd_full + (n*n) * even_full - (n+1) * odd_corners + n * even_corners
  end

end


lines = Solution.readLines()
visited = Solution.gao(lines)
IO.inspect(visited)

# 596734601954383
# 596734624471510
# 596734624269210
