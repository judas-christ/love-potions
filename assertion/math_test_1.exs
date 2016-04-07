defmodule MathTest do
  use Assertion

  test "ints can be added and subtracted" do
    assert 1 + 1 == 2
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end

  test "other" do
    assert 2 == 2
  end
end
