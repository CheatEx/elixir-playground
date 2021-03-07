defmodule SimpleCache.Sup do
  alias SimpleCache.Element

  use DynamicSupervisor, restart: :permanent

  @spec start_child(term(), pos_integer()) :: DynamicSupervisor.on_start_child()
  def start_child(value, lease_time) do
    spec = %{
      id: Element,
      start: {Element, :start_link, [value, lease_time]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
