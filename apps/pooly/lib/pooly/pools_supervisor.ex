defmodule Pooly.PoolsSupervisor do
  use Supervisor

  def start_link do
    IO.puts "PoolsSuprevisor start"
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    IO.puts "PoolsSuprevisor init"
    opts = [
      strategy: :one_for_one
    ]
    supervise([], opts)
  end

end
