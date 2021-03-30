defmodule GenWebServer.Sup do
  use Supervisor

  def start_link(port = arg) when is_integer(port) do
    Supervisor.start_link(__MODULE__, arg)
  end

  @impl true
  def init({callback_module, port, user_arg} = _arg) do
    conn_sup_name =
      "#{Atom.to_string(GenWebServer.ListenerSupervisor)}_#{Integer.to_string(port)}"
      |> String.to_atom()
    server_init_arg = [
      port: port,
      conn_sup: conn_sup_name,
      callback_module: callback_module,
      user_arg: user_arg]
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: conn_sup_name},
      {GenWebServer.SocketServer, server_init_arg}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
