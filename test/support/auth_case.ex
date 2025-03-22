defmodule HelpcenterWeb.AuthCase do
  def login(conn, user) do
    case AshAuthentication.Jwt.token_for_user(user, %{}, domain: Helpcenter.Accounts) do
      {:ok, token, _claims} ->
        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> Plug.Conn.put_session(:user_token, token)

      :error ->
        raise "Failed to generate token}"
    end
  end

  def create_user do
    Helpcenter.Accounts.User
    |> Ash.Seed.seed!(%{email: "kamaro.tester@example.com"})
  end
end
