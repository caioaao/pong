defmodule Pong.Core.Match.Event do
  alias Pong.Core.{Player}

  @type player_request_name() ::
          :move_pad_left | :move_pad_right | :join_match | :pause | :unpause
  @type t() ::
          :match_created
          | {:tick, number()}
          | {:player_request, player_request_name(), Player.id()}
end
