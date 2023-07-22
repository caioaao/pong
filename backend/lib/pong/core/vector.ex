defmodule Pong.Core.Vector do
  @type t() :: {number(), number()}

  @spec scale(t(), number()) :: t()
  def scale({x, y}, r) do
    {x * r, y * r}
  end

  @spec add(t(), t()) :: t()
  def add({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  @spec sub(t(), t()) :: t()
  def sub({x1, y1}, {x2, y2}) do
    {x1 - x2, y1 - y2}
  end

  @spec dot(t(), t()) :: number()
  def dot({x1, y1}, {x2, y2}) do
    x1 * x2 + y1 * y2
  end

  # cross product will only result in a vector in the `z` axis. we just return
  # the magnitude of this vector
  @spec cross(t(), t()) :: number()
  def cross({x1, y1}, {x2, y2}) do
    x1 * y2 - x2 * y1
  end

  @spec magnitude(t()) :: number()
  def magnitude({x, y}) do
    :math.sqrt(x * x + y * y)
  end

  @doc """
  direction returns a unit vector with the same direction as the original vector
  """
  @spec direction(t()) :: t()
  def direction(v) do
    scale(v, 1 / magnitude(v))
  end
end
