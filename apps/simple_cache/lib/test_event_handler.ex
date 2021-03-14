defmodule TestEventHandler do
  require Logger

  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl true
  def init(_arg) do
    {:ok, {}}
  end

  @impl true
  def handle_cast(msg, state) do
    Logger.info("Received #{inspect(msg)}")
    {:noreply, state}
  end
end
