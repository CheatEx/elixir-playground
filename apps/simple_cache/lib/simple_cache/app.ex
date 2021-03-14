defmodule SimpleCache.App do
  alias SimpleCache.Store
  alias SimpleCache.Sup
  alias SimpleCache.EventManager

  use Application

  @impl true
  def start(_type, _args) do
    Store.init()
    port = Application.get_env(:simple_cache, :tcp_port, 1155)

    children = [
      {Sup, []},
      {EventManager, []},
      {SimpleCache.Tcp.Sup, port}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SimpleCache.App.Root)
  end
end
