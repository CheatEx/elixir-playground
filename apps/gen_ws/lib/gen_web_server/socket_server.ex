defmodule GenWebServer.SocketServer do
  use GenServer

  defmodule State do
    defstruct port: nil, conn_sup: nil, lsock: nil, callback_module: nil, user_arg: nil
  end

  @spec start_link(
          port: pos_integer(),
          conn_sup: pid() | atom(),
          callback_module: module(),
          user_arg: atom()
        ) :: GenServer.on_start()
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
    callback_module = Keyword.fetch!(params, :callback_module)
    user_arg = Keyword.fetch!(params, :user_arg)

    {:ok, lsock} = :gen_tcp.listen(port, active: false, packet: :http_bin, reuseaddr: true)

    state = %State{
      port: port,
      conn_sup: conn_sup,
      lsock: lsock,
      callback_module: callback_module,
      user_arg: user_arg
    }

    start_listener(state)
    {:ok, state}
  end

  @impl true
  def handle_cast({:accepted, lsock}, %State{lsock: lsock} = state) do
    start_listener(state)
    {:noreply, state}
  end

  defp start_listener(%State{
         conn_sup: conn_sup,
         lsock: lsock,
         callback_module: callback_module,
         user_arg: user_arg
       }) do
    DynamicSupervisor.start_child(
      conn_sup,
      {GenWebServer.ConnectionHandler, {self(), lsock, callback_module, user_arg}}
    )
  end
end
