defmodule Pong.Core.Field do
  alias Pong.Core.{LineSegment}

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
end
