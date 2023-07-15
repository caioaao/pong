defmodule Backend.Game.State do
  @type t() :: %{
          ball: %{pos: Backend.Engine.Point.t(), velocity: Backend.Engine.Vector.t()},
          player1_pad: %{pos: Backend.Engine.Point.t()},
          player2_pad: %{pos: Backend.Engine.Point.t()},
          score: {integer(), integer()}
        }
end
