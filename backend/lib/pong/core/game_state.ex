defmodule Pong.Core.GameState do
  @type t() :: %{
          ball: %{pos: Pong.Engine.Point.t(), velocity: Pong.Engine.Vector.t()},
          player1_pad: %{pos: Pong.Engine.Point.t()},
          player2_pad: %{pos: Pong.Engine.Point.t()},
          score: {integer(), integer()}
        }
end
