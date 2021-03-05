defmodule SimpleCache.Store do
  @table_id __MODULE__

  @spec init() :: :ok
  def init() do
    :ets.new(@table_id, [:public, :named_table])
    :ok
  end

  @spec insert(term(), pid()) :: :ok
  def insert(key, pid) do
    :ets.insert(@table_id, {key, pid})
    :ok
  end

  @spec lookup(term()) :: {:ok, pid()} | {:error, atom()}
  def lookup(key) do
    case :ets.lookup(@table_id, key) do
      [{_key, pid}] -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end

  @spec delete(pid()) :: :ok
  def delete(pid) do
    :ets.match_delete(@table_id, {'_', pid})
    :ok
  end
end
