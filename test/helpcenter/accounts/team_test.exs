defmodule Helpcenter.Accounts.TeamTest do
  use HelpcenterWeb.ConnCase, async: false
  import HelpcenterWeb.AuthCase
  require Ash.Query

  describe "Team tests" do
    test "User team can be created" do
      # Create a user (imported from ConnCase)
      user = create_user()
      # Define team attributes
      team_attrs = %{name: "Team 1", domain: "team_1", owner_user_id: user.id}
      {:ok, team} = Ash.create!(Helpcenter.Accounts.Team, team_attrs)

      # Verify the team was stored successfully
      assert Helpcenter.Accounts.Team
             |> Ash.Query.filter(domain == ^team.domain)
             |> Ash.Query.filter(owner_user_id == ^team.owner_user_id)
             |> Ash.exists?()

      # Check if the team is set as the user's current_team
      assert Helpcenter.Accounts.User
             |> Ash.Query.filter(id == ^user.id)
             |> Ash.Query.filter(current_team == ^team.domain)
             |> Ash.exists?(authorize?: false)

      # Confirm the team is in the user's teams list
      assert Helpcenter.Accounts.User
             |> Ash.Query.filter(id == ^user.id)
             |> Ash.Query.filter(teams.id == ^team.id)
             |> Ash.exists?(authorize?: false)
    end
  end
end
