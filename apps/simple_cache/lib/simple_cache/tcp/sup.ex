defmodule SimpleCache.Tcp.Sup do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(arg) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: SimpleCache.Tcp.LSup},
      {SimpleCache.Tcp.Server, arg}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
