defmodule TestModule do
  @behaviour GenWebServer

  @impl GenWebServer
  def init(term) do
    {:ok, []}
  end

  @impl GenWebServer
  def get(path, headers, _user_data) do
    IO.puts("GET #{path} #{inspect(headers)}")
  end

  @impl GenWebServer
  def head(path, headers, _user_data) do
    IO.puts("HEAD #{path} #{inspect(headers)}")
  end

  @impl GenWebServer
  def put(path, headers, body, _user_data) do
    IO.puts("PUT #{path} #{inspect(headers)} <body skipped>")
  end

  @impl GenWebServer
  def put(path, headers, body, _user_data) do
    IO.puts("POST #{path} #{inspect(headers)} <body skipped>")
  end

  @impl GenWebServer
  def delete(path, headers, _user_data) do
    IO.puts("DELETE #{path} #{inspect(headers)}")
  end

  @impl GenWebServer
  def other(method, path, headers, body, _user_data) do
    IO.puts("#{method} #{path} #{inspect(headers)} <body skipped>")
  end
end
