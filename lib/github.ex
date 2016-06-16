defmodule Github.Repo do
  def get(token, repo_full_name) do
    Github.get(token, "/repos/#{repo_full_name}")
  end

  def get(token, owner, repo) do
    get(token, "#{owner}/#{repo}")
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
  @base_url Application.get_env(:beer_napkin, :github_api_url)
  @http_module Application.get_env(:beer_napkin, :http_module)

  def get(token, path) do
    case @http_module.get(@base_url <> path, headers(token)) do
      {:ok, response} ->
        json     = response.body
        Poison.decode!(json)
      {:error, _} -> %{}
    end
  end

  def post(token, path, data) do
    {:ok, body} = Poison.encode(data)
    {:ok, data} = Poison.decode(@http_module.post!(@base_url <> path, body, headers(token)).body)
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
