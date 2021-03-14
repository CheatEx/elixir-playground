defmodule SimpleCache.Tcp.Server do
  alias SimpleCache.Tcp.LSup

  use GenServer

  def start_link() do
    port = Application.get_env(:simple_cache, :tcp_port, 1155)
    GenServer.start_link(__MODULE__, [port])
  end

  @impl true
  def init([port]) do
    {:ok, lsock} = :gen_tcp.listen(port, [active: true])
    LSup.start_child(lsock)
  end

end
