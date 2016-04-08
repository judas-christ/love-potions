defmodule Loop do
  defmacro while(clause, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          if unquote(clause) do
            unquote(block)
          else
            break
          end
        end
      catch
        :break -> :ok
      end
    end
  end

  def break do
    throw :break
  end
end
