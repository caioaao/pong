defmodule Pong.Core.LineSegment do
  alias Pong.Core.{Point, Vector}

  @type t() :: {Point.t(), Point.t()}

  @spec distance_to_point(t(), Point.t()) :: number()
  def distance_to_point({v, w}, p) do
    l2 = Point.dist2(v, w)
    vw = Vector.sub(w, v)
    vp = Vector.sub(p, v)

    t =
      (Vector.dot(vp, vw) / l2)
      |> max(0)
      |> min(1)

    proj = Vector.add(v, Vector.scale(vw, t))
    Point.dist(p, proj)
  end

  @spec length(t()) :: number()
  def length({a, b}) do
    Point.dist(a, b)
  end
end
