defmodule GenWebServer do
  @type request :: term()
  @type method :: String.t()
  @type headers :: [{String.t(), String.t()}]
  @type reply :: term()
  @type user_data :: term()
  @type body :: binary()

  @callback init(term()) :: {:ok, user_data}
  @callback get(request, headers, user_data) :: :ok
  @callback delete(request, headers, user_data) :: :ok
  @callback head(request, headers, user_data) :: :ok
  @callback post(request, headers, body, user_data) :: :ok
  @callback put(request, headers, body, user_data) :: :ok
  @callback other(method, request, headers, body, user_data) :: :ok

  @spec start_link(module(), pos_integer(), term()) :: GenServer.on_start()
  def start_link(callback_module, port, user_arg) do
    Supervisor.start_link(GenWebServer.Sup, {callback_module, port, user_arg})
  end

  @spec reply(pos_integer()) :: reply
  def reply(code), do: reply(code, "")

  @spec reply(pos_integer(), iodata()) :: reply
  def reply(code, body), do: reply(code, [{"Content-Type", "text"}], body)

  @spec reply(pos_integer(), headers, iodata()) :: reply
  def reply(code, headers, body) when is_binary(body) do
    length = IO.iodata_length(body)

    [
      "HTTP/1.1 #{response(code)}\r\n#{headers(headers)}Content-Length: #{length}\r\n\r\n",
      body
    ]
  end

  defp response(100), do: "100 Continue"
  defp response(200), do: "200 OK"
  defp response(404), do: "404 Not Found"
  defp response(501), do: "501 Not Implemented"

  defp response(code) when is_integer(code) do
    "#{code}"
  end

  defp headers([{name, value} | tail]) do
    ["#{name}: #{value}\r\n" | headers(tail)]
  end

  defp headers([]), do: []
end
