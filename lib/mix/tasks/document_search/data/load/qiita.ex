defmodule Mix.Tasks.DocumentSearch.Data.Load.Qiita do
  use Mix.Task

  @shortdoc "Load data from Qiita"
  def run(_args) do
    HTTPoison.start
    DocumentSearch.Repo.start_link

    tag = "groonga"
    url = "https://qiita.com/api/v2/items?page=1&per_page=100&query=tag:#{tag}"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    Poison.Parser.parse!(body)
    |> Enum.map(fn entry ->
      params = %{title: entry["title"], content: entry["body"]}
      DocumentSearch.Document.changeset(%DocumentSearch.Document{}, params)
    end)
    |> Enum.each(&DocumentSearch.Repo.insert!/1)
  end
end
