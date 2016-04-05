defmodule Assertions do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertions.Test.assert operator, lhs, rhs
    end
  end
end

defmodule Assertions.Test do
  def assert(:==, lhs, rhs) when lhs == rhs do
    IO.write "."
  end
  def assert(:==, lhs, rhs) do
    IO.puts """
    FAILURE:
      Expected:    #{lhs}
      to be equal: #{rhs}
    """
  end

  def assert(:>, lhs, rhs) when lhs > rhs do
    IO.write "."
  end
  def assert(:>, lhs, rhs) do
    IO.puts """
    FAILURE:
      Expected:           #{lhs}
      to be greater than: #{rhs}
    """
  end
end
