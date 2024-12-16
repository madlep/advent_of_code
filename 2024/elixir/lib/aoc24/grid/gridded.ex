defprotocol Aoc24.Grid.Gridded do
  alias Aoc24.Grid.Position

  @type t(_v) :: t()

  @spec at(t(v), Position.t()) :: v when v: var
  def at(g, position)

  @spec at!(t(v), Position.t()) :: v when v: var
  def at!(g, position)

  @spec delete(t(v), Position.t()) :: t(v) when v: var
  def delete(g, position)

  @spec put(t(v), Position.t(), v) :: t(v) when v: var
  def put(g, position, element)

  @spec put!(t(v), Position.t(), v) :: t(v) when v: var
  def put!(g, position, element)

  @spec height(t(_v)) :: integer() when _v: var
  def height(g)

  @spec width(t(_v)) :: integer() when _v: var
  def width(g)
end
