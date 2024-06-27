defmodule CircleciClientTest do
  use ExUnit.Case
  doctest CircleciClient

  test "greets the world" do
    assert CircleciClient.hello() == :world
  end
end
