defmodule SimpleCache.Sup do
  alias SimpleCache.Element

  use DynamicSupervisor

  def child_spec(arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg]},
      restart: :permanent
    }
  end

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def start_child(value, lease_time) do
    spec = %{
      id: Element,
      start: {Element, :start_link, [value, lease_time]},
      restart: :temporary
    }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
