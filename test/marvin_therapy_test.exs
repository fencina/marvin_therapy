defmodule MarvinTherapyTest do
  use ExUnit.Case
  doctest MarvinTherapy

  test "greets the world" do
    assert MarvinTherapy.hello() == :world
  end
end
