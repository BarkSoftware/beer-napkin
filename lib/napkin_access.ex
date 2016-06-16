defmodule NapkinAccess do
  def can_access?(user, napkin) do
    case (napkin.user_id == user.id) || has_push?(user, napkin.repository_full_name) do
      true -> {:ok, napkin}
      false -> {:unauthorized, "You need to have push access to the repository to gain access."}
    end
  end

  defp has_push?(user, repo_name) do
    Github.Repo.get(user.token, repo_name)["permissions"]["push"] == true
  end
end
