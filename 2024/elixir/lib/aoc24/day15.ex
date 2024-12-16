defmodule Aoc24.Day15 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, 1)

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, 2)

  defp run(input, scale_x) do
    {map_robot, movements} = parse(input, scale_x)

    {map, _robot} =
      movements
      |> Enum.reduce(map_robot, fn move, {map, robot} ->
        move_robot(robot, map, move)
      end)

    map
    |> Grid.positions()
    |> Enum.filter(&(Grid.at(map, &1) in ["[", "O"]))
    |> Enum.map(&gps/1)
    |> Enum.sum()
  end

  defp move_robot(robot, map, move) do
    case maybe_push_boxes(map, maybe_robot = move_pos(robot, move), move) do
      {:ok, new_map} -> {new_map, maybe_robot}
      :blocked -> {map, robot}
    end
  end

  defp maybe_push_boxes(map, {x, y} = pos, move) do
    move_contents = Grid.at(map, pos)

    case move_contents do
      nil -> {:ok, map}
      "#" -> :blocked
      "O" -> maybe_push_box(map, pos, move)
      "[" -> maybe_push_wide_box(map, pos, {x + 1, y}, move)
      "]" -> maybe_push_wide_box(map, {x - 1, y}, pos, move)
    end
  end

  defp maybe_push_box(map, pos, move) do
    with moved_box_pos = move_pos(pos, move),
         {:ok, map} <- maybe_push_boxes(map, moved_box_pos, move) do
      {:ok, map |> Grid.move(pos, moved_box_pos)}
    end
  end

  defp maybe_push_wide_box(map, left_pos, right_pos, move = "<") do
    with moved_left_pos = move_pos(left_pos, move),
         moved_right_pos = move_pos(right_pos, move),
         {:ok, map} <- maybe_push_boxes(map, moved_left_pos, move) do
      {:ok, map |> Grid.move(left_pos, moved_left_pos) |> Grid.move(right_pos, moved_right_pos)}
    end
  end

  defp maybe_push_wide_box(map, left_pos, right_pos, move = ">") do
    with moved_left_pos = move_pos(left_pos, move),
         moved_right_pos = move_pos(right_pos, move),
         {:ok, map} <- maybe_push_boxes(map, moved_right_pos, move) do
      {:ok, map |> Grid.move(right_pos, moved_right_pos) |> Grid.move(left_pos, moved_left_pos)}
    end
  end

  defp maybe_push_wide_box(map, left_pos, right_pos, move) do
    with moved_left_pos = move_pos(left_pos, move),
         moved_right_pos = move_pos(right_pos, move),
         {:ok, map} <- maybe_push_boxes(map, moved_left_pos, move),
         {:ok, map} <- maybe_push_boxes(map, moved_right_pos, move) do
      {:ok, map |> Grid.move(left_pos, moved_left_pos) |> Grid.move(right_pos, moved_right_pos)}
    end
  end

  defp move_pos(pos, move) do
    case move do
      "^" -> Position.up(pos)
      "v" -> Position.down(pos)
      "<" -> Position.left(pos)
      ">" -> Position.right(pos)
    end
  end

  defp gps({x, y}), do: x + y * 100

  defp parse(input, scale_x) do
    [map_input, movements_input] = String.split(input, "\n\n", parts: 2, trim: true)
    {parse_map2(map_input, scale_x), parse_movements(movements_input)}
  end

  defp parse_map2(input, 1), do: sparse_grid(input, reduce: {:raw, &reducer/2, nil})
  defp parse_map2(input, 2), do: sparse_grid(input, reduce: {:raw, &reducer2/2, nil})

  defp reducer({robot_pos, "@"}, {g, nil}), do: {g, robot_pos}
  defp reducer({pos, "O"}, {g, acc}), do: {g |> Grid.put(pos, "O"), acc}
  defp reducer({pos, "#"}, {g, acc}), do: {g |> Grid.put(pos, "#"), acc}

  defp reducer2({{x, y}, "@"}, {g, nil}), do: {g, {x * 2, y}}

  defp reducer2({{x, y}, "O"}, {g, acc}),
    do: {g |> Grid.put({x * 2, y}, "[") |> Grid.put({x * 2 + 1, y}, "]"), acc}

  defp reducer2({{x, y}, "#"}, {g, acc}),
    do: {g |> Grid.put({x * 2, y}, "#") |> Grid.put({x * 2 + 1, y}, "#"), acc}

  defp parse_movements(input), do: input |> String.replace("\n", "") |> String.graphemes()
end
