defmodule Helpcenter.Accounts.PermissionTest do
  use HelpcenterWeb.ConnCase
  require Ash.Query

  test "can add a permission" do
    # Try to add a permission
    new_permission = %{action: "read", resource: "category"}
    {:ok, _} = Ash.create(Helpcenter.Accounts.Permission, new_permission)

    # Check if it exists
    exists? =
      Helpcenter.Accounts.Permission
      |> Ash.Query.filter(action == "read" and resource == "category")
      |> Ash.exists?()

    assert exists?
  end
end
