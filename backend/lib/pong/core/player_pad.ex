defmodule Pong.Core.PlayerPad do
  alias Pong.Core.{Rectangle}

  @move_delta 5

  @type t() :: %{geometry: Rectangle.t()}

  @spec move_left(t()) :: t()
  def move_left(pad) do
    update_in(pad, [:geometry], fn geom ->
      Rectangle.move(geom, {-@move_delta, 0}) |> Rectangle.ensure_inside_viewport()
    end)
  end

  @spec move_right(t()) :: t()
  def move_right(pad) do
    update_in(pad, [:geometry], fn geom ->
      Rectangle.move(geom, {@move_delta, 0}) |> Rectangle.ensure_inside_viewport()
    end)
  end
end
