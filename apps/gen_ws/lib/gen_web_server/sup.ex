defmodule GenWebServer.Sup do
  use Supervisor

  def start_link(port = arg) when is_integer(port) do
    Supervisor.start_link(__MODULE__, arg)
  end

  @impl true
  def init(port = _arg) do
    name =
      "#{Atom.to_string(GenWebServer.ListenerSupervisor)}_#{Integer.to_string(port)}"
      |> String.to_atom()
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: name},
      {GenWebServer.SocketServer, [port: port, lconn_sup: name]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
