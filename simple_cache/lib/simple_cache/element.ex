defmodule SimpleCache.Element do
  alias SimpleCache.Store

  use GenServer

  def fetch(pid) do
    GenServer.call(pid, :fetch)
  end

  def replace(pid, new_value) do
    GenServer.cast(pid, {:replace, new_value})
  end

  def delete(pid) do
    GenServer.cast(pid, :delete)
  end

  def start_link(value, lease_time) do
    GenServer.start_link(__MODULE__, [value, lease_time])
  end

  defmodule State do
    defstruct value: nil, lease_time: nil, start_time: nil
  end

  @impl true
  def init([value, lease_time]) do
    now = :calendar.local_time()
    start_time = :calendar.datetime_to_gregorian_seconds(now)
    {:ok, %State{value: value, lease_time: lease_time, start_time: start_time}}
  end

  @impl true
  def handle_call(:fetch, _from, state) do
    {:reply, {:ok, state.value}, state, time_left(state)}
  end

  @impl true
  def handle_cast({:replace, new_value}, state) do
    {:noreply, %{state | value: new_value}, time_left(state)}
  end

  @impl true
  def handle_cast(:delete, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl true
  def terminate(_reason, _state) do
    Store.delete(self())
  end

  defp time_left(%State{lease_time: :infinity}) do
    :infinity
  end

  defp time_left(%State{lease_time: lease_time, start_time: start_time}) do
    now = :calendar.local_time()
    current_time = :calendar.datetime_to_gregorian_seconds(now)
    elapsed_time = current_time - start_time

    case lease_time - elapsed_time do
      t when t > 0 -> t * 1000
      _ -> 0
    end
  end
end
