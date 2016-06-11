defmodule Github.Repo do
  def get(token, owner, repo) do
    Github.get(token, "/repos/#{owner}/#{repo}")
  end
end

defmodule Github.Search do
  def search(token, q) do
    Github.get(token, "/search/repositories?" <> search_string(q))
  end

  defp search_string(q) do
    URI.encode_query(%{"q" => q})
  end
end

defmodule Github do
  @base_url "https://api.github.com"

  def get(token, path) do
    {:ok, data} = Poison.decode(HTTPoison.get!(@base_url <> path, headers(token)).body)
    data
  end

  def post(token, path, data) do
    {:ok, body} = Poison.encode(data)
    {:ok, data} = Poison.decode(HTTPoison.post!(@base_url <> path, body, headers(token)).body)
    data
  end

  defp headers(token) do
    [{"Authorization", "token " <> token}]
  end
end

defmodule Github.Issue do
  def create(token, repo_name, title, body) do
    result = Github.post(token, "/repos/#{repo_name}/issues", %{
      title: title,
      body: body
    })
  end
end
