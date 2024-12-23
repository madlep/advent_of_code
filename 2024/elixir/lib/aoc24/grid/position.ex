defmodule Aoc24.Grid.Position do
  @type t() :: {x :: integer(), y :: integer()}
  @type delta() :: {x :: integer(), y :: integer()}

  @spec dir(t(), t()) :: t()
  def dir({x1, y1}, {x2, y2}), do: {x2 - x1, y2 - y1}

  @spec move(t(), delta()) :: t()
  def move({x, y}, {dx, dy}), do: {x + dx, y + dy}

  @spec new(x :: integer(), y :: integer()) :: t()
  def new(x, y), do: {x, y}

  @neighbour_dirs [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

  @spec neighbours(t()) :: Enumerable.t(t())
  def neighbours({x, y}), do: for({dx, dy} <- @neighbour_dirs, do: {x + dx, y + dy})

  @spec rotate_left(t()) :: t()
  def rotate_left({x, y}), do: {y, x * -1}

  @spec rotate_right(t()) :: t()
  def rotate_right({x, y}), do: {y * -1, x}

  @spec up(t()) :: t()
  def up({x, y}), do: {x, y - 1}

  @spec down(t()) :: t()
  def down({x, y}), do: {x, y + 1}

  @spec left(t()) :: t()
  def left({x, y}), do: {x - 1, y}

  @spec up(t()) :: t()
  def right({x, y}), do: {x + 1, y}

  @spec within_manhattan(t(), range :: integer()) :: Enumerable.t(t())
  def within_manhattan(pos, range) do
    -range..range
    |> Stream.flat_map(fn yi ->
      x_2 = range - abs(yi)

      -x_2..x_2
      |> Stream.map(fn xi ->
        move(pos, {xi, yi})
      end)
    end)
  end

  @spec manhattan_distance(t(), t()) :: integer()
  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)
end
