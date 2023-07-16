defmodule Pong.Core.GameState do
  @type t() :: %{
          ball: %{pos: Pong.Engine.Point.t(), velocity: Pong.Engine.Vector.t()},
          player1_pad: %{pos: Pong.Engine.Point.t()},
          player2_pad: %{pos: Pong.Engine.Point.t()},
          score: {integer(), integer()}
        }

  @spec new() :: t()
  def new() do
    %{
      ball: %{pos: {50, 50}, velocity: {0, 0}},
      player1_pad: %{pos: {50, 20}},
      player2_pad: %{pos: {50, 80}},
      score: {0, 0}
    }
  end

  def detect_collisions(curr_state) do
  end
end
