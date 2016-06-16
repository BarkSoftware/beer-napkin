defmodule NapkinAccessSpec do
  use ESpec
  alias BeerNapkin.Napkin
  alias BeerNapkin.User
  alias BeerNapkin.Repo

  describe "can_access?" do
    context "when the user owns the napkin" do
      before do
        user = junk_user
        napkin = junk_napkin(user)
        {:shared, napkin: napkin, user: user}
      end
      subject(NapkinAccess.can_access?(shared.user, shared.napkin))
      it do: is_expected.to eq({:ok, shared.napkin})
    end
    context "when the user does not own the napkin" do
      before do
        user = junk_user
        another_user = junk_user
        napkin = junk_napkin(another_user)
        {:shared, napkin: napkin, user: user}
      end
      subject(NapkinAccess.can_access?(shared.user, shared.napkin))
      context "when the user does not have push access to the repository" do
        before do
          json_body = Poison.encode!(%{"permissions" => %{"push" => false}})
          http_response = {:ok, %{body: json_body, status_code: 200}}
          setup_github_request(shared.user, shared.napkin, http_response)
          {:shared, napkin: shared.napkin, user: shared.user}
        end

        it do: is_expected.to eq({:unauthorized, "You need to have push access to the repository to gain access."})
      end

      context "when the user has push access to the repository" do
        before do
          json_body = Poison.encode!(%{"permissions" => %{"push" => true}})
          http_response = {:ok, %{body: json_body, status_code: 200}}
          setup_github_request(shared.user, shared.napkin, http_response)
          {:shared, napkin: shared.napkin, user: shared.user}
        end

        it do: is_expected.to eq({:ok, shared.napkin})
      end
    end
  end

  defp setup_github_request(user, napkin, http_response) do
    token = user.token
    repo_name = napkin.repository_full_name
    url = Application.get_env(:beer_napkin, :github_api_url) <> "/repos/#{repo_name}"
    headers = [{"Authorization", "token " <> token}]
    allow(HTTPMock).to accept(:get, fn(^url, ^headers) -> http_response end)
  end

  defp junk_user do
    user_changeset = User.changeset(%User{}, %{
      username: SecureRandom.uuid,
      image: SecureRandom.uuid,
      token: SecureRandom.uuid
    })
    {:ok, user} = Repo.insert(user_changeset)
    user
  end

  defp junk_napkin(user) do
    napkin_changeset = Napkin.changeset(%Napkin{}, %{
      user_id: user.id,
      json: "{}",
      token: SecureRandom.uuid,
      image_url: "test"
    })
    {:ok, napkin} = Repo.insert(napkin_changeset)
    napkin
  end
end
