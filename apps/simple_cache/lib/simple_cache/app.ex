defmodule SimpleCache.App do
  alias SimpleCache.Store
  alias SimpleCache.Sup
  alias SimpleCache.EventManager

  use Application

  @impl true
  def start(type, args) do
    Store.init()

    children = [
      {Sup, []},
      {EventManager, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SimpleCache.App.Root)
  end
end
