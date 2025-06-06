defmodule Helpcenter.KnowledgeBase.ArticleTag do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "article_tags"
    repo Helpcenter.Repo
  end

  actions do
    default_accept [:article_id, :tag_id]
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
    timestamps()
  end

  relationships do
    belongs_to :article, Helpcenter.KnowledgeBase.Article do
      source_attribute :article_id
    end

    belongs_to :tag, Helpcenter.KnowledgeBase.Tag do
      source_attribute :tag_id
    end
  end

  identities do
    identity :unique_article_tag, [:article_id, :tag_id]
  end
end
