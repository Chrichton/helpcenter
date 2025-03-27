defmodule Helpcenter.KnowledgeBase.Tag do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tags"
    repo Helpcenter.Repo
  end

  actions do
    default_accept [:name, :slug]
    defaults [:create, :read, :update, :destroy]
  end

  preparations do
    prepare Helpcenter.Preparations.SetTenant
  end

  changes do
    # Auto-set tenant based on the user/actor
    change Helpcenter.Changes.SetTenant
  end

  # Make this resource multi-tenant
  multitenancy do
    strategy :context
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :slug, :string
    timestamps()
  end

  relationships do
    many_to_many :articles, Helpcenter.KnowledgeBase.Article do
      through Helpcenter.KnowledgeBase.ArticleTag
      source_attribute_on_join_resource :tag_id
      destination_attribute_on_join_resource :article_id
    end
  end

  aggregates do
    count :article_count, :articles
  end
end
