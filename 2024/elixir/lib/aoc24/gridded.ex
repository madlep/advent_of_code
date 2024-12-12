defprotocol Aoc24.Gridded do
  @type t(_v) :: t()

  @spec at(t(v), Aoc24.Position.t()) :: v when v: var
  def at(g, position)

  @spec at!(t(v), Aoc24.Position.t()) :: v when v: var
  def at!(g, position)

  @spec put(t(v), Grid.position(), v) :: t(v) when v: var
  def put(g, position, element)

  @spec height(t(_v)) :: integer() when _v: var
  def height(g)

  @spec width(t(_v)) :: integer() when _v: var
  def width(g)
end
