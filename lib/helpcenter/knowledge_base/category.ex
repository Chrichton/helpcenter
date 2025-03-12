defmodule Helpcenter.KnowledgeBase.Category do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer,
    # Tell Ash to broadcast/ Emit events via pubsub
    notifiers: Ash.Notifier.PubSub

  postgres do
    table "categories"
    repo Helpcenter.Repo

    # # Delete related articles when a category is destroyed to prevent
    # leave records behind
    references do
      reference :articles, on_delete: :delete
    end
  end

  actions do
    # Tell Ash what columns to accept while inserting or updating
    default_accept [:name, :slug, :description]
    # Tell Ash what actions are allowed on this resource
    defaults [:create, :read, :update, :destroy]

    update :create_article do
      description "Create an article under a specified category"
      # Set atomic to false since this is a 2-steps operation.
      require_atomic? false
      # Specify the parameter that will hold article attributes
      # he article_attrs map must have the same fields as the fields required to create an article
      argument :article_attrs, :map, allow_nil?: false
      change manage_relationship(:article_attrs, :articles, type: :create)
    end

    create :create_with_article do
      description "Create a Category and an article under it"
      argument :article_attrs, :map, allow_nil?: false
      change manage_relationship(:article_attrs, :articles, type: :create)
    end

    read :most_recent do
      prepare Helpcenter.Preparations.LimitTo5
      prepare Helpcenter.Preparations.MonthToDate
      prepare Helpcenter.Preparations.OrderByMostRecent
    end
  end

  # Configure how ash will work with pubsub on this resource.
  pub_sub do
    # 1. Tell Ash to use HelpcenterWeb.Endpoint for publishing events
    module HelpcenterWeb.Endpoint

    # Prefix all events from this resource with category. This allows us
    # to subscribe only to events starting with "categories" in livew view
    prefix "categories"

    # Define event topic or names. Below configuration will be publishing
    # topic of this format whenever an action of update, create or delete
    # happens:
    #    "categories"
    #    "categories:UUID-PRIMARY-KEY-ID-OF-CATEGORY"
    #
    #  You can pass any other parameter available on resource like slug
    publish_all :update, [[:id, nil]]
    publish_all :create, [[:id, nil]]
    publish_all :destroy, [[:id, nil]]
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

  # Relationship Block. In this case this resource has many articles
  relationships do
    has_many :articles, Helpcenter.KnowledgeBase.Article do
      description "Relationship with the articles."

      # Tell Ash that the articles table has a column named "category_id" that references this resource
      destination_attribute :category_id
    end
  end

  aggregates do
    count :article_count, :articles
  end
end
