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
end
