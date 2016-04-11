ExUnit.start
Code.require_file("linq.exs", __DIR__)

defmodule LinqTest do
  use ExUnit.Case

  defmodule Entity do

  end

  test "from something" do
    import Linq

    ast = quote do: from entity in Entity,
      select: entity
    IO.inspect ast
  end
end
