# Solution from *A Geometric solution to advent of code 2023, day 21* :
# https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21

# It is probably wrong.

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
    visited = Map.put(%{}, start, 1)
    bfs_helper(lines, queue, visited)
    |> Map.values()
  end

  def gao(lines, even_corners_ans) do
    visited = bfs(lines, {65, 65})

    odd_corners = visited
    |> Enum.filter(fn x -> rem(x, 2) == 1 and x > 65 end)
    |> Enum.count()

    even_full = visited
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
    |> Enum.count()

    odd_full = visited
    |> Enum.filter(fn x -> rem(x, 2) == 1 end)
    |> Enum.count()

    n = 202300 # ((26501365 - (131 / 2)) / 131)

    ((n+1)*(n+1)) * odd_full + (n*n) * even_full - (n+1) * odd_corners + even_corners_ans
  end

end


lines = Solution.readLines()

visited_left_up = Solution.bfs(lines, {0, 0})
visited_right_up = Solution.bfs(lines, {130, 0})
visited_left_down = Solution.bfs(lines, {0, 130})
visited_right_down = Solution.bfs(lines, {130, 130})

even_corners_left_up = visited_left_up
|> Enum.filter(fn x -> rem(x, 2) == 0 and x <= 65 end)
|> Enum.count()

even_corners_right_up = visited_right_up
|> Enum.filter(fn x -> rem(x, 2) == 0 and x <= 65 end)
|> Enum.count()

even_corners_left_down = visited_left_down
|> Enum.filter(fn x -> rem(x, 2) == 0 and x <= 65 end)
|> Enum.count()

even_corners_right_down = visited_right_down
|> Enum.filter(fn x -> rem(x, 2) == 0 and x <= 65 end)
|> Enum.count()

even_corners = even_corners_left_up + even_corners_right_up + even_corners_left_down + even_corners_right_down

even_corners_ans = Integer.floor_div(even_corners, 4) * even_corners

visited = Solution.gao(lines, even_corners_ans)
IO.inspect(visited)

# 596734624471510 too high
# 596733864166729 too low
