defmodule GenWebServer.ConnectionHandler do
  use GenServer, restart: :transient

  defmodule State do
    defstruct server: nil,
              lsock: nil,
              sock: nil,
              request_line: nil,
              headers: [],
              body: "",
              content_remainig: 0,
              callback_module: nil,
              user_arg: nil
  end

  @spec start_link({pid(), :gen_tcp.socket(), module(), term()}) :: GenServer.on_start()
  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl true
  def init({server, lsock, callback_module, user_arg}) do
    state = %State{
      server: server,
      lsock: lsock,
      callback_module: callback_module,
      user_arg: user_arg
    }

    {:ok, state, {:continue, []}}
  end

  @impl true
  def handle_continue(_arg, %State{server: server, lsock: lsock} = state) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    # GenWebServer.SocketServer.accepted(server, lsock)
    :inet.setopts(sock, active: :once)
    {:noreply, %{state | sock: sock}}
  end

  @impl true
  def handle_info({:http, _sock, {:http_request, _, _, _} = request}, state) do
    :inet.setopts(state.sock, active: :once)
    {:noreply, %{state | request_line: request}}
  end

  @impl true
  def handle_info({:http, _sock, {:http_header, _, _, name, value}}, state) do
    :inet.setopts(state.sock, active: :once)
    {:noreply, process_header(name, value, state)}
  end

  @impl true
  def handle_info({:http, _sock, :http_eoh}, %State{content_remainig: 0} = state) do
    {:stop, :normal, handle_request(state)}
  end

  @impl true
  def handle_info({:http, _sock, :http_eoh}, state) do
    :inet.setopts(state.sock, active: :once, packet: :raw)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, _sock, data}, %State{} = state) when is_binary(data) do
    content_rem = state.content_remainig - byte_size(data)
    body = IO.iodata_to_binary([state.body, data])
    new_state = %State{state | content_remainig: content_rem, body: body}

    if content_rem > 0 do
      :inet.setopts(state.sock, active: :once)
      {:noreply, new_state}
    else
      {:stop, :normal, handle_request(new_state)}
    end
  end

  @impl true
  def handle_info({:tcp_closed, _sock}, state) do
    {:stop, :normal, state}
  end

  defp process_header("Content-Length" = name, value, state) do
    content_length = Integer.parse(name)
    %State{state | content_remainig: content_length, headers: [{name, value} | state.headers]}
  end

  defp process_header("Expect" = name, "100-continue" = value, state) do
    # TODO :gen_tcp.s
    %State{state | headers: [{name, value} | state.headers]}
  end

  defp process_header(name, value, state) do
  end

  defp handle_request(state) do
  end
end
