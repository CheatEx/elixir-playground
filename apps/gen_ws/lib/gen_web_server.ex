defmodule GenWebServer do
  @type path :: String.t()
  @type headers :: [{String.t(), String.t()}]

  @type reply :: term()

  @type user_data :: term()

  @callback init(term()) :: {:ok, user_data}
  @callback get(path, headers, user_data) :: :ok

  @spec start_link(module(), pos_integer(), term()) :: GenServer.on_start()
  def start_link(callback_module, port, user_arg) do

  end

  @spec reply(pos_integer()) :: reply
  def reply(code) do

  end

  @spec reply(pos_integer(), String.t() | binary() | iolist()) :: reply
  def reply(code, body) when is_binary(body) do

  end

  def reply(code, body) do
    reply(code, IO.iodata_to_binary(body))
  end
end
