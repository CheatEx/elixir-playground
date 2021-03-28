defmodule GenWebServer.SocketServer do
  alias GenWebServer.ConnectionHandler

  use GenServer

  defstruct port: nil, conn_sup: nil, lsock: nil

  @spec start_link([port: pos_integer(), conn_sup: pid() | atom()]) :: GenServer.on_start()
  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  @spec accepted(pid(), :gen_tcp.socket()) :: :ok
  def accepted(server, lsock) do
    GenServer.cast(server, {:accepted, lsock})
  end

  @impl true
  def init(params) do
    port = Keyword.fetch!(params, :port)
    conn_sup = Keyword.fetch!(params, :conn_sup)
    {:ok, lsock} = :gen_tcp.listen(port, active: true)
    start_listener(lsock, conn_sup)
    state = %SocketServer{port: port, conn_sup: conn_sup, lsock: lsock}
    {:ok, state}
  end

  @impl true
  def handle_cast({:accepted, lsock}, %SocketServer{conn_sup: conn_sup, lsock: lsock} = state) do
    start_listener(lsock, conn_sup)
    {:noreply, state}
  end

  defp start_listener(lsock, conn_sup) do
    DynamicSupervisor.start_child(conn_sup, {ConnectionHandler, {self(), lsock}})
  end
end
