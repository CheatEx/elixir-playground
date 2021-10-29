defmodule SimpleCacheServerTest do
  use ExUnit.Case
  doctest SimpleCacheServer

  test "greets the world" do
    assert SimpleCacheServer.hello() == :world
  end
end
