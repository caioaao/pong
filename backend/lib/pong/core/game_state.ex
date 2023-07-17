defmodule Pong.Core.GameState do
  alias Pong.Core.{Circle, PlayerPad}

  @type t() :: %{
          ball: %{geometry: Circle.t(), velocity: Pong.Core.Vector.t()},
          player1_pad: PlayerPad.t(),
          player2_pad: PlayerPad.t(),
          score: {integer(), integer()}
        }

  @spec new() :: t()
  def new() do
    %{
      ball: %{geometry: %{radius: 5, center: {50, 50}}, velocity: {0, 0}},
      player1_pad: %{geometry: %{center: {50, 20}, width: 20, height: 2}},
      player2_pad: %{geometry: %{center: {50, 80}, width: 20, height: 2}},
      score: {0, 0}
    }
  end
end
