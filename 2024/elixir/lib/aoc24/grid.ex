defmodule Aoc24.Grid do
  @type position() :: {x :: integer(), y :: integer()}

  defguard in_bounds(position, w, h)
           when elem(position, 0) in 0..(w - 1)//1 and elem(position, 1) in 0..(h - 1)//1
end
