defmodule SimpleCache.EventManager do
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

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_handler(handler_module, init_arg) do
    child_spec = %{
      id: handler_module,
      start: {handler_module, :start_link, init_arg},
      restart: :temporary,
      shutdown: :brutal_kill
    }
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def notify_create(key, value) do
    notify({:create, key, value})
  end

  def notify_replace(key, value) do
    notify({:replace, key, value})
  end

  def notify_delete(key) do
    notify({:delete, key})
  end

  def notify_fetch(key) do
    notify({:fetch, key})
  end

  defp notify(msg) do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.cast(pid, msg)
    end
    :ok
  end
end
