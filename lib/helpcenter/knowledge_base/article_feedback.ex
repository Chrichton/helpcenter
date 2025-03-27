defmodule Helpcenter.KnowledgeBase.ArticleFeedback do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "article_feedbacks"
    repo Helpcenter.Repo
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

    attribute :helpful, :boolean, default: false
    attribute :feedback, :string, allow_nil?: true

    create_timestamp :created_at
  end

  relationships do
    belongs_to :article, Helpcenter.KnowledgeBase.Article do
      source_attribute :article_id
      allow_nil? false
    end
  end
end
