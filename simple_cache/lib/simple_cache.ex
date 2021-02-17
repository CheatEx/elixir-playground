defmodule SimpleCache do
  alias SimpleCache.Store
  alias SimpleCache.Element
  alias SimpleCache.Sup
  alias SimpleCache.EventManager

  @default_lease_time 60 * 60 * 24

  def insert(key, value) do
    case Store.lookup(key) do
      {:ok, pid} ->
        Element.replace(pid, value)
        EventManager.notify_replace(key, value)
      {:error, _} ->
        {:ok, pid} = Sup.start_child(value, @default_lease_time)
        Store.insert(key, pid)
        EventManager.notify_create(key, value)
    end
  end

  def lookup(key) do
    with {:ok, pid} <- Store.lookup(key),
         {:ok, value} <- Element.fetch(pid) do
      EventManager.notify_fetch(key)
      {:ok, value}
    else
      _ -> {:error, :not_found}
    end
  end

  def delete(key) do
    case Store.lookup(key) do
      {:ok, pid} ->
        EventManager.notify_delete(key)
        Element.delete(pid)
      {:error, :not_found} -> :ok
      _ -> {:error, :other}
    end
  end
end
