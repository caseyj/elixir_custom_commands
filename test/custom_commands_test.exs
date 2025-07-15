defmodule CustomCommandsTest do
  use ExUnit.Case
  doctest CustomCommands

  test "greets the world" do
    assert CustomCommands.hello() == :world
  end
end
