defmodule GenWebServer.ConnectionHandler do
  use GenServer, restart: :transient

  defstruct server: nil,
            lsock: nil,
            sock: nil,
            request_line: nil,
            headers: [],
            body: "",
            content_remainig: 0,
            callback_module: nil,
            user_arg: nil

  @spec start_link({pid(), :gen_tcp.socket(), module(), term()}) :: GenServer.on_start()
  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl true
  def init({server, lsock, callback_module, user_arg}) do
    state = %ConnectionHandler{
      server: server,
      lsock: lsock,
      callback_module: callback_module,
      user_arg: user_arg
    }

    {:ok, state, {:continue, []}}
  end

  @impl true
  def handle_continue(_arg, %ConnectionHandler{server: server, lsock: lsock} = state) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    # GenWebServer.SocketServer.accepted(server, lsock)
    :inet.setopts(sock, active: once)
    {:noreply, %{state | sock: sock}}
  end

  @impl true
  def handle_info({:http, _sock, {:http_request, _, _, _} = request}, state) do
    :inet.setopts(state.sock, active: once)
    {:noreply, %{state | request_line: request}}
  end

  @impl true
  def handle_info({:http, _sock, {:http_header, _, name, _, value}}, state) do
    :inet.setopts(state.sock, active: once)
    {:noreply, process_header(name, value, state)}
  end

  @impl true
  def handle_info({:http, _sock, :http_eoh}, %ConnectionHandler{content_remainig: 0} = state) do
    {:stop, :normal, handle_request(state)}
  end

  @impl true
  def handle_info({:http, _sock, :http_eoh}, state) do
    :inet.setopts(state.sock, active: :once, packet: :raw)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, _sock, data}, state) do
    # TODO
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    {:stop, :normal, state}
  end
end
