defmodule Backend.App do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Backend.Http.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Backend.App
      )
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    Logger.info("Starting app")

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/dummy", Backend.Http.DummyWebSocketHandler, []},
         {"/ws/[...]", Backend.Http.WebSocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Backend.Http.Router, []}}
       ]}
    ]
  end
end
