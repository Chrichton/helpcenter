defmodule Helpcenter.KnowledgeBase.Article do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "articles"
    repo Helpcenter.Repo

    # Delete this article if related category is deleted
    references do
      reference :category, on_delete: :delete
    end

    # 1. Nullify category_id column on article when related category is deleted
    # references do
    #   reference :category, on_delete: :nilify
    # end
  end

  changes do
    change Helpcenter.Changes.Slugify
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :slug, :string
    attribute :content, :string
    attribute :views_count, :integer, default: 0
    attribute :published, :boolean, default: false
    # Automatically adds, inserted_at and updated_at columns
    timestamps()
  end

  relationships do
    belongs_to :category, Helpcenter.KnowledgeBase.Category do
      source_attribute :category_id
      allow_nil? false

      # for 1. Nullify category_id column on article when related category is deleted
      # category_id can be null when there is no related category
      # allow_nil? true
    end

    has_many :comments, Helpcenter.KnowledgeBase.Comment do
      destination_attribute :article_id
    end

    # Many-to-many relationship with Tag
    many_to_many :tags, Helpcenter.KnowledgeBase.Tag do
      through Helpcenter.KnowledgeBase.ArticleTag
      source_attribute_on_join_resource :article_id
      destination_attribute_on_join_resource :tag_id
    end

    has_many :article_feedbacks, Helpcenter.KnowledgeBase.ArticleFeedback do
      destination_attribute :article_id
    end

    actions do
      default_accept [:title, :slug, :content, :views_count, :published, :category_id]
      defaults [:create, :read, :update, :destroy]

      create :create_with_category do
        description "Create an article and its category at the same time"
        argument :category_attrs, :map, allow_nil?: false
        change manage_relationship(:category_attrs, :category, type: :create)
      end

      create :create_with_tags do
        description "Create an article with tags"
        argument :tags, {:array, :map}, allow_nil?: false

        change manage_relationship(:tags, :tags,
                 on_no_match: :create,
                 on_match: :ignore,
                 on_missing: :create
               )
      end
    end

    aggregates do
      count :comment_count, :comments
      count :tag_count, :tags
    end
  end
end
