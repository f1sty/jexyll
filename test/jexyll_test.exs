defmodule JexyllTest do
  use ExUnit.Case
  doctest Jexyll

  test "greets the world" do
    assert Jexyll.hello() == :world
  end
end
