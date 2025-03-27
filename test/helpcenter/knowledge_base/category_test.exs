defmodule Helpcenter.KnowledgeBase.CategoryTest do
  alias HelpcenterWeb.AuthCase
  use HelpcenterWeb.ConnCase, async: false
  import AuthCase
  require Ash.Query

  describe "Knowledge Base Category Tests" do
    test "Can create a category" do
      user = create_user()

      # Create a category, expecting current_team to set the tenant
      cat_attrs = %{name: "Billing", description: "testing"}

      category =
        Helpcenter.KnowledgeBase.Category
        |> Ash.Changeset.for_create(:create, cat_attrs, actor: user)
        |> Ash.create!()

      # Confirm the category’s tenant matches the user’s current_team
      assert user.current_team == Ash.Resource.get_metadata(category, :tenant)

      # Check that the data landed in the database
      assert category.name == cat_attrs.name
      assert category.description == cat_attrs.description
      # Make sure timestamps aren’t null
      refute category.inserted_at |> is_nil()
      refute category.updated_at |> is_nil()
    end
  end
end
