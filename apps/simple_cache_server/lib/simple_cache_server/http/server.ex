defmodule SimpleCacheServer.Http.Server do
  @behaviour GenWebServer

  def child_spec(port) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [port]}
    }
  end

  @spec start_link(pos_integer()) :: GenServer.on_start()
  def start_link(port), do: GenWebServer.start_link(__MODULE__, port, [])

  @impl GenWebServer
  def init(_arg), do: {:ok, []}

  @impl GenWebServer
  def get({:abs_path, "/" <> key}, _headers, _user_data) do
    case SimpleCache.lookup(key) do
      {:ok, value} -> GenWebServer.reply(200, value)
      {:error, :not_found} -> GenWebServer.reply(404)
    end
  end

  @impl GenWebServer
  def put({:abs_path, "/" <> key}, _headers, body, _user_data) do
    SimpleCache.insert(key, body)
    GenWebServer.reply(200)
  end

  @impl GenWebServer
  def delete({:abs_path, "/" <> key}, _headers, _user_data) do
    SimpleCache.delete(key)
  end

  @impl GenWebServer
  def post(_path, _headers, _body, _user_data) do
    GenWebServer.reply(501)
  end

  @impl GenWebServer
  def head(_path, _headers, _user_data) do
    GenWebServer.reply(501)
  end

  @impl GenWebServer
  def other(_method, _path, _headers, _body, _user_data) do
    GenWebServer.reply(501)
  end
end
