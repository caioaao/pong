defmodule Pong.App do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Pong.Api.Http.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      {DynamicSupervisor, name: Pong.Core.Match.ServerSupervisor, strategy: :one_for_one},
      Pong.Core.Match.Registry.child_spec([])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    Logger.info("Starting app")

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/dummy", Pong.Api.Http.DummyWebSocketHandler, []},
         {"/ws/[...]", Pong.Api.Http.WebSocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Pong.Api.Http.Router, []}}
       ]}
    ]
  end
end
