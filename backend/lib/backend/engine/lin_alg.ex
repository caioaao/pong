defmodule Engine.LinAlg do
  @type vec() :: {number(), number()}
  @type point() :: vec()

  @spec scale(vec(), number()) :: vec()
  def scale({x, y}, r) do
    {x * r, y * r}
  end

  @spec add(vec(), vec()) :: vec()
  def add({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  @spec translate(point(), vec()) :: point()
  def translate(p, v) do
    add(p, v)
  end
end
