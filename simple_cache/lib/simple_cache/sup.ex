defmodule SimpleCache.Sup do
  alias SimpleCache.Element

  use DynamicSupervisor

  @spec start_child(term(), pos_integer()) :: DynamicSupervisor.on_start_child()
  def start_child(value, lease_time) do
    spec = %{
      id: Element,
      start: {Element, :start_link, [value, lease_time]},
      restart: :temporary
    }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @spec child_spec(term()) :: Supervisor.child_spec()
  def child_spec(arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg]},
      restart: :permanent
    }
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
