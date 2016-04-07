defmodule Hub do
  HTTPotion.start
  @username "judas-christ"

  "https://api.github.com/users/#{@username}/repos"
  |> HTTPotion.get([headers: ["User-Agent": "Elixir"]])
  |> Map.get(:body)
  |> Poison.decode!
  |> Enum.each fn repo ->
    def unquote(String.to_atom(repo["name"]))() do
      unquote(Macro.escape(repo))
    end
  end

  def go(repo) do
    url = apply(__MODULE__, repo, [])["html_url"]
    IO.puts "Launching browser to #{url}..."
    open_url(:os.type, url)
  end

  defp open_url({:win32, :nt}, url) do
    System.cmd("cmd", ["/c", "start", url])
  end
  defp open_url({:unix, :darwin}, url) do
    System.cmd("open", [url])
  end
end


