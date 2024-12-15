defmodule Aoc24.Day15 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {map_robot, movements} = parse(input)

    {map, _robot} =
      movements
      |> Enum.reduce(map_robot, fn move, {map, robot} ->
        move_robot(robot, map, move)
      end)

    map
    |> Grid.positions()
    |> Enum.filter(&(Grid.at(map, &1) == "O"))
    |> Enum.map(&gps/1)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp move_robot(robot, map, move) do
    case maybe_push_boxes(map, maybe_robot = move_pos(robot, move), move) do
      {:ok, new_map} -> {new_map, maybe_robot}
      :blocked -> {map, robot}
    end
  end

  defp maybe_push_boxes(map, pos, move) do
    move_contents = Grid.at(map, pos)

    case move_contents do
      nil ->
        {:ok, map}

      "#" ->
        :blocked

      "O" ->
        moved_box_pos = move_pos(pos, move)

        case maybe_push_boxes(map, moved_box_pos, move) do
          {:ok, new_map} -> {:ok, new_map |> Grid.delete(pos) |> Grid.put(moved_box_pos, "O")}
          :blocked -> :blocked
        end
    end
  end

  defp move_pos(pos, move) do
    case move do
      "^" ->
        Position.up(pos)

      "v" ->
        Position.down(pos)

      "<" ->
        Position.left(pos)

      ">" ->
        Position.right(pos)
    end
  end

  defp gps({x, y}), do: x + y * 100

  defp parse(input) do
    [map_input, movements_input] = String.split(input, "\n\n", parts: 2, trim: true)
    {parse_map(map_input), parse_movements(movements_input)}
  end

  defp parse_map(input), do: sparse_grid(input, reduce_with: &grid_reducer/2)

  defp grid_reducer({robot_pos, "@"}, _acc), do: {:discard, robot_pos}
  defp grid_reducer({_pos, char}, acc), do: {:keep, char, acc}

  defp parse_movements(input), do: input |> String.replace("\n", "") |> String.graphemes()
end
