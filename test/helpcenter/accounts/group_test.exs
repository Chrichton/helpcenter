defmodule Helpcenter.Accounts.GroupTest do
  alias HelpcenterWeb.AuthCase
  use HelpcenterWeb.ConnCase
  require Ash.Query
  import AuthCase

  test "can add a group" do
    # Helper to make a user
    user = create_user()
    group_attrs = %{name: "Accountants", description: "Handles billing"}
    {:ok, _} = Ash.create(Helpcenter.Accounts.Group, group_attrs, actor: user)

    assert Helpcenter.Accounts.Group
           |> Ash.Query.filter(name == ^group_attrs.name)
           |> Ash.Query.filter(description == ^group_attrs.description)
           |> Ash.exists?(actor: user)
  end
end
