defmodule Pong.Core.Match.StateMachine do
  @moduledoc """
  Implements state machine and transitions for the game. Uses the mathematical
  definition explained in erlang's gen_statem docs[1]:

  State(S) x Event(E) -> Actions(A), State(S') 

  Where processing an event E with the current state S results in the actions A
  taken to transform the state into S'.

  While returning actions might seem like an overkill, it's nice because we can
  generate new events from it, and send them to listeners.

  [1] https://www.erlang.org/doc/design_principles/statem.html
  """
  alias Pong.Core.{Match}
  alias Pong.Core.Match.{Event}

  @spec process_event(Match.state(), Event.t()) :: Match.state()

  ######################################
  # CREATED STATE processing functions
  ######################################

  def process_event(
        %{state: :created, millis_left_until_timeout: millis_left} = match,
        {:tick, ellapsed_millis}
      ) do
    if millis_left <= ellapsed_millis do
      %{state: :canceled}
    else
      Map.update!(match, :millis_left_until_timeout, &(&1 - ellapsed_millis))
    end
  end

  def process_event(
        %{state: :created, players_ready: players_ready} = match,
        {:player_request, :join_match, player_id}
      ) do
    players_ready = MapSet.put(players_ready, player_id)

    if MapSet.size(players_ready) >= 2 do
      %{state: :starting, millis_left_until_start: 3000}
    else
      Map.put(match, :players_ready, players_ready)
    end
  end

  ######################################
  # STARTING STATE processing functions
  ######################################
  def process_event(
        %{state: :starting, millis_left_until_start: millis_left} = match,
        {:tick, ellapsed_millis}
      ) do
    if millis_left <= ellapsed_millis do
      Match.start()
    else
      Map.update!(match, :millis_left_until_start, &(&1 - ellapsed_millis))
    end
  end

  ######################################
  # IN PROGRESS state processing functions
  ######################################
  def process_event(
        state = %{state: :in_progress},
        {:tick, _}
      ) do
    state
  end

  def process_event(state, _evt) do
    state
  end
end
