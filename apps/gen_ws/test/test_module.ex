defmodule TestModule do
  @behaviour GenWebServer

  @impl GenWebServer
  def init(term) do
    {:ok, []}
  end

  @impl GenWebServer
  def get({:abs_path, path}, headers, _user_data) do
    IO.puts("GET #{path} #{inspect(headers)}")
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def head({:abs_path, path}, headers, _user_data) do
    IO.puts("HEAD #{path} #{inspect(headers)}")
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def put({:abs_path, path}, headers, _body, _user_data) do
    IO.puts("PUT #{path} #{inspect(headers)} <body skipped>")
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def put({:abs_path, path}, headers, _body, _user_data) do
    IO.puts("POST #{path} #{inspect(headers)} <body skipped>")
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def delete({:abs_path, path}, headers, _user_data) do
    IO.puts("DELETE #{path} #{inspect(headers)}")
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def other(method, {:abs_path, path}, headers, _body, _user_data) do
    IO.puts("[#{inspect(method)}] #{path} #{inspect(headers)} <body skipped>")
    GenWebServer.reply(200)
  end
end
