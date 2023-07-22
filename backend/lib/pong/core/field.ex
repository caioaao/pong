defmodule Pong.Core.Field do
  alias Pong.Core.{LineSegment, Point}

  def default_width, do: 100
  def default_height, do: 100

  @typedoc """
  tuple of {width, height}
  """
  @type t() :: {number(), number()}

  @spec left_edge(t()) :: LineSegment.t()
  def left_edge({_, height}) do
    {{0, 0}, {0, height}}
  end

  @spec right_edge(t()) :: LineSegment.t()
  def right_edge({width, height}) do
    {{width, 0}, {width, height}}
  end

  @spec top_edge(t()) :: LineSegment.t()
  def top_edge({width, height}) do
    {{0, height}, {width, height}}
  end

  @spec bottom_edge(t()) :: LineSegment.t()
  def bottom_edge({width, _}) do
    {{0, 0}, {width, 0}}
  end

  @spec center_x(t()) :: Point.t()
  def center_x({width, _}) do
    width / 2
  end

  @spec center_y(t()) :: Point.t()
  def center_y({_, height}) do
    height / 2
  end

  @spec center(t()) :: Point.t()
  def center(field) do
    {center_x(field), center_y(field)}
  end
end
