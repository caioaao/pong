defmodule Pong.Core.Match do
  alias Pong.Core.{Player}

  @type created() :: %{
          state: :created,
          millis_left_until_timeout: number(),
          players_ready: MapSet.t(Player.id())
        }

  @type starting() :: %{
          state: :starting,
          millis_left_until_start: number()
        }

  # TODO
  @type in_progress() :: %{
          state: :in_progress
        }

  @type finished() :: %{
          state: :finished,
          winner: Player.id()
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
end
