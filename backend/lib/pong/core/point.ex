defmodule Pong.Core.Point do
  alias Pong.Core.{Vector}

  @type t() :: {number(), number()}

  @spec translate(t(), Vector.t()) :: t()
  def translate(point, vec) do
    Vector.add(point, vec)
  end

  @spec dist(t(), t()) :: number()
  def dist(p1, p2) do
    :math.sqrt(dist2(p1, p2))
  end

  @spec dist2(t(), t()) :: number()
  def dist2({x1, y1}, {x2, y2}) do
    (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
  end
end
