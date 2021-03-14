defmodule SimpleCacheServer.Tcp.Listener do
  alias SimpleCacheServer.Tcp.Server

  use GenServer, restart: :transient

  # TODO get spec
  # @spec start_link(list()) :: GenServer.on_start()
  def start_link({server, _lsock} = arg) when is_pid(server) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl true
  def init({server, lsock}) do
    {:ok, {server, lsock}, {:continue, []}}
  end

  @impl true
  def handle_continue(_arg, {server, lsock} = state) do
    {:ok, _sock} = :gen_tcp.accept(lsock)
    Server.accepted(server, lsock)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, socket, data}, state) do
    new_state = handle_data(socket, data, state)
    {:noreply, new_state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    {:stop, :normal, state}
  end

  defp handle_data(socket, data, state) do
    :gen_tcp.send(socket, data)
    state
  end
end
