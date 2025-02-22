defmodule Helpcenter.KnowledgeBase.Category do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "categories"
    repo Helpcenter.Repo

    # # Delete related articles when a category is destroyed to prevent
    # # leave records behind
    # references do
    #   reference :articles, on_delete: :delete
    # end
  end

  # Tell Ash what columns the resource has and their types and validations
  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :slug, :string
    attribute :description, :string, allow_nil?: true
    # Automatically adds, inserted_at and updated_at columns
    timestamps()
  end

  # # Relationship Block. In this case this resource has many articles
  # relationships do
  #   has_many :articles, Helpcenter.KnowledgeBase.Article do
  #     description "Relationship with the articles."
  #     # Tell Ash that the articles table has a column named "category_id" that references this resource
  #     destination_attribute :category_id
  #   end
  #  end
end
