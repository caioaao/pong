defmodule Pong.Api.Http.Encode do
  require Jason
  @spec state_to_wire(Pong.Core.GameState.t()) :: {:ok, String.t()} | {:error, any}
  def state_to_wire(s) do
    s
    |> update_in([:ball, :geometry, :center], &prepare_xy_to_encode/1)
    |> update_in([:ball, :velocity], &prepare_xy_to_encode/1)
    |> update_in([:player1_pad, :geometry, :center], &prepare_xy_to_encode/1)
    |> update_in([:player2_pad, :geometry, :center], &prepare_xy_to_encode/1)
    |> update_in([:score], fn {a, b} -> %{player1: a, player2: b} end)
    |> Map.put(:is_paused, s[:paused?])
    |> Map.delete(:paused?)
    |> Map.put(:finished, s[:finished?])
    |> Map.delete(:finished?)
    |> Map.update!(:pending_players, fn players ->
      MapSet.to_list(players) |> Enum.map(&to_string/1)
    end)
    |> Jason.encode()
  end

  @spec prepare_xy_to_encode({number(), number()}) :: any
  defp prepare_xy_to_encode({x, y}) do
    %{x: x, y: y}
  end
end
