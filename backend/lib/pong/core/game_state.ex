defmodule Pong.Core.GameState do
  alias Pong.Core.{Circle, Rectangle}

  @type t() :: %{
          ball: %{shape: Circle.t(), velocity: Pong.Core.Vector.t()},
          player1_pad: %{shape: Rectangle.t()},
          player2_pad: %{shape: Rectangle.t()},
          score: {integer(), integer()}
        }

  @spec new() :: t()
  def new() do
    %{
      ball: %{shape: %{radius: 5, center: {50, 50}}, velocity: {0, 0}},
      player1_pad: %{shape: %{center: {50, 20}, width: 20, height: 2}},
      player2_pad: %{shape: %{center: {50, 80}, width: 20, height: 2}},
      score: {0, 0}
    }
  end
end
