defmodule Pong.Core.Match do
  alias Pong.Core.{Player, Ball, PlayerPad}

  @type created() :: %{
          state: :created,
          millis_left_until_timeout: number(),
          players_ready: MapSet.t(Player.id())
        }

  @type starting() :: %{
          state: :starting,
          millis_left_until_start: number()
        }

  @type in_progress() :: %{
          state: :in_progress,
          score: {number(), number()},
          ball: Ball.t(),
          player1_pad: PlayerPad.t(),
          player2_pad: PlayerPad.t()
        }

  @type paused() :: %{
          state: :paused,
          prev_state: in_progress()
        }

  @type finished() :: %{
          state: :finished,
          winner: Player.id(),
          final_score: {number(), number()}
        }

  @type canceled() :: %{state: :canceled}

  @type state() :: created() | starting() | in_progress() | finished() | canceled()

  @match_id_chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  def gen_id(len \\ 8) do
    Stream.repeatedly(fn -> :rand.uniform(String.length(@match_id_chars)) - 1 end)
    |> Enum.take(len)
    |> Enum.map(&String.at(@match_id_chars, &1))
    |> List.to_string()
  end

  @spec start() :: in_progress()
  def start() do
    %{
      state: :in_progress,
      ball: %{
        geometry: %{radius: Ball.radius(), center: {50, 50}},
        velocity: Ball.initial_velocity()
      },
      player1_pad: %{geometry: %{center: {50, 10}, width: 20, height: 2}},
      player2_pad: %{geometry: %{center: {50, 90}, width: 20, height: 2}},
      score: {0, 0}
    }
  end
end
