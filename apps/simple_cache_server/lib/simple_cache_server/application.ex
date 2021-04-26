defmodule SimpleCacheServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:simple_cache_sercer, :tcp_port, 1155)
    http_port = Application.get_env(:simple_cache_sercer, :tcp_port, 1188)

    children = [
      {SimpleCacheServer.Tcp.Sup, port},
      {SimpleCacheServer.Http.Server, http_port}
    ]

    opts = [strategy: :one_for_one, name: SimpleCacheServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
