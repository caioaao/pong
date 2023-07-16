defmodule Pong.Engine.Shape.LineSegment do
  alias Pong.Engine.{Point, Vector}

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

defmodule Pong.Engine.Shape.Circle do
  alias Pong.Engine.{Point}
  alias Pong.Engine.Shape.{LineSegment, Rectangle}

  @type t() :: %{radius: number(), center: Point.t()}

  @spec intersects_line_segment?(t(), LineSegment.t()) :: boolean()
  def intersects_line_segment?(circle, segment) do
    LineSegment.distance_to_point(segment, circle[:center]) < circle[:radius]
  end

  @spec intersects_rectangle?(t(), Rectangle.t()) :: boolean()
  def intersects_rectangle?(circle, rect) do
    Rectangle.edges(rect)
    |> Enum.any?(fn edge -> intersects_line_segment?(circle, edge) end)
  end
end

defmodule Pong.Engine.Shape.Rectangle do
  alias Pong.Engine.{Point}
  alias Pong.Engine.Shape.{LineSegment, Circle}

  @type t() :: %{center: Point.t(), width: number(), height: number()}

  @spec edges(t()) :: {LineSegment.t(), LineSegment.t(), LineSegment.t(), LineSegment.t()}
  def edges(rect) do
    {a, b, c, d} = vertices(rect)

    {
      {a, b},
      {b, c},
      {c, d},
      {d, a}
    }
  end

  @doc """
  Returns rectangles vertices in counter-clockwise order, starting from the top-right vertex
  """
  @spec vertices(t()) :: {Point.t(), Point.t(), Point.t(), Point.t()}
  def vertices(%{center: {x, y}, width: width, height: height}) do
    dx = width / 2
    dy = height / 2

    {
      {x + dx, y + dy},
      {x - dx, y + dy},
      {x - dx, y - dy},
      {x + dx, y - dy}
    }
  end

  @spec intersects_circle?(t(), Circle.t()) :: boolean()
  def intersects_circle?(rect, circle) do
    Circle.intersects_rectangle?(circle, rect)
  end
end
