defmodule GenWebServerTest do
  use ExUnit.Case
  doctest GenWebServer

  test "greets the world" do
    assert GenWebServer.hello() == :world
  end
end
