defmodule ShareAsGithubIssue do
  def share(token, repo_name, image_url, napkin_url, title, body) do
    link = "[![mockups by beer napkin](#{image_url})](#{napkin_url})"
    body = body <> link
    issue = Github.Issue.create(token, repo_name, title, body)
    issue["url"]
  end
end
