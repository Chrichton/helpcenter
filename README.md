# Helpdesk

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Steps

**Create Project Helpdesk**
mix archive.install hex phx_new

mix igniter.new helpcenter \
 --install ash,ash_postgres,ash_phoenix \
 --with phx.new \
 --extend postgres

**Link**:
[HexDocs Ash Getting started](https://hexdocs.pm/ash/get-started.html)

**Create Domain and Resource**
mix ash.gen.domain Helpcenter.KnowledgeBase
mix ash.gen.resource Helpcenter.KnowledgeBase.Category --extend postgres
mix ash.gen.resource Helpcenter.KnowledgeBase.Article --extend postgres
mix ash.gen.resource Helpcenter.KnowledgeBase.Comment --extend postgres
mix ash.gen.resource Helpcenter.KnowledgeBase.Tag --extend postgres
mix ash.gen.resource Helpcenter.KnowledgeBase.ArticleTag --extend postgres
mix ash.gen.resource Helpcenter.KnowledgeBase.ArticleFeedback --extend postgres

**Create Migrations**
mix ash_postgres.generate_migrations — name add_knowledge_base_tables
mix ash_postgres.migrate

**Actions**
actions do

# Tell Ash what columns to accept while inserting or updating

default_accept [:name, :slug, :description]

# Tell Ash what actions are allowed on this resource

defaults [:create, :read, :update, :destroy]
end

## Database Access

**Seeding**

```
attrs = [
%{
  name: "Account and Login",
  slug: "account-login",
  description: "Help with account creation, login issues, and profile management"
},
%{
  name: "Billing and Payments",
  slug: "billing-payments",
  description: "Assistance with invoices, subscription plans, and payment issues"
}
]
```

Ash.Seed.seed!(Helpcenter.KnowledgeBase.Category, attrs)

**Creating a Record With Ash.Create**
category_params = %{name: "Billing", slug: "billing", description: "Refund requests, billings and account issues"}

Helpcenter.KnowledgeBase.Category
|> Ash.Changeset.for_create(:create, category_params)
|> Ash.create()

**Reading Record(s) with Ash.read**
Ash.read(ResourceName)
Ash.read(Helpcenter.KnowledgeBase.Category)

**Conditional with Ash.Query.filter**
_You must require Ash.Query before you can use Ash.Query.filter_

require Ash.Query

Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(name == "General Support")
|> Ash.read()

**Update Record(s) with Ash.Update**
require Ash.Query

Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(name == "System Setup and Integration")
|> Ash.read_first!()
|> Ash.Changeset.for_update(:update, %{name: "Integration"})
|> Ash.update()

**Destroying Record(s) with Ash.Destroy**
require Ash.Query

Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(name == "Approvals and Workflows")
|> Ash.read_first!()
|> Ash.destroy()

**Creating an Article under a Category**

# 1. Get category to create an article under. Assume it exists already

category = Ash.read_first!(Helpcenter.KnowledgeBase.Category)

# 2. Prepare new article data

```
article_attrs = %{
  views_count: 1452,
  title: "Getting Started with Zippiker",
  slug: "getting-started-zippiker",
  content: "Learn how to set up your Zippiker account and configure basic settings.",
  published: true
}
```

# Insert a Has Many Relationship via manage_relationship

# Create an article under his category

_:create_article is a Category Action_

category
|> Ash.Changeset.for_update(:create_article, %{article_attrs: article_attrs})
|> Ash.update()

**Find the article**

require Ash.Query
Helpcenter.KnowledgeBase.Article
|> Ash.Query.filter(title == "Getting Started with Zippiker")
|> Ash.read!()

_for finding a substring, you can use the contains() expression_

require Ash.Query
Helpcenter.KnowledgeBase.Article
|> Ash.Query.filter(contains(title, "etting Started with Zippiker"))
|> Ash.read()

# Create Parent and The Child the Same Time

# Create a Category with it's Article

_Category Action_

```
create :create_with_article do
  description "Create a Category and an article under it"
  argument :article_attrs, :map, allow_nil?: false
  change manage_relationship(:article_attrs, :articles, type: :create)
end
```

# Define category and related article attributes

```
attributes = %{
  name: "Features",
  slug: "features",
  description: "Category for features",
  article_attrs: %{
    title: "Compliance Features in Zippiker",
    slug: "compliance-features-zippiker",
    content: "Overview of compliance management features built into Zippiker."
  }
}
```

# Create category and its article at the same time

Helpcenter.KnowledgeBase.Category
|> Ash.Changeset.for_create(:create_with_article, attributes)
|> Ash.create()

# Retrieve Relationships with Ash.Query.load/1

require Ash.Query

category_with_articles =
(Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(name == "Features")
|> Ash.Query.load(:articles)
|> Ash.read_first!())

_Then access category articles like: category_with_articles.articles_

**Belongs To**

- Add category_id attribute to artist list of accepts
- **Attention**: you don't have to add category_id to the attributes of artist

```
attributes = %{
  title: "Common Issues During Setup and How to Fix Them",
  slug: "setup-common-issues",
  content: "Troubleshooting guide for common challenges faced.",
  category_id: category_with_articles.id # Assumes you've retrieved a category from DB
}
```

Helpcenter.KnowledgeBase.Article
|> Ash.Changeset.for_create(:create, attributes)
|> Ash.create()

# Create Child and Parent at the Same Time

```
attributes = %{
 title: "Common Issues During Setup and How to Fix Them",
 slug: "setup-common-issues",
 content: "Troubleshooting guide for common challenges faced.",
 category_attrs: %{
   name: "Troubleshooting",
   slug: "troubleshooting",
   description: "Diagnose and fix identified issues"
 }
}


Helpcenter.KnowledgeBase.Article
|> Ash.Changeset.for_create(:create_with_category, attributes)
|> Ash.create()
```

# Part 4 — Ash Framework for Phoenix Developers — Relationshps 2/2

# Many To Many Relationship Through Another Resource

category = (Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(name == "General Support")
|> Ash.read_first!())

```
attributes = %{
  title: "Common Issues During Setup and How to Fix Them",
  slug: "setup-common-issues",
  content: "Troubleshooting guide for common challenges faced.",
  category_id: category.id,
  tags: [%{name: "issues"}, %{name: "solution"}]
}
```

article = (Helpcenter.KnowledgeBase.Article
|> Ash.Changeset.for_create(:create_with_tags, attributes)
|> Ash.create!())

# Has One

[Has One Relationship](https://hexdocs.pm/ash/relationships.html#has-one)

# Filtering With Relationship(A.K.A Where Conditions)

```
require Ash.Query

Helpcenter.KnowledgeBase.Article
|> Ash.Query.filter(tags.name == "issues")
|> Ash.read!()
```

```
require Ash.Query

Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(articles.tags.name == "issues")
|> Ash.read!()
```

# Retrieving Nested Relationships

```
Helpcenter.KnowledgeBase.Category
|> Ash.Query.filter(articles.tags.name == "issues")
|> Ash.Query.load(articles: :tags)
|> Ash.read!()
```

_Note how I wrote articles: :tags this special notation tells Ash that you will load articles and corresponding tags for each article_

# Deleting Record With Related Records(Relationship) or Nullifying Related Records Instead of Deleting Them

# On Data Layer (Postgres)

_make changes to the Article resource_

Deleting Record is implemented, Nullifying is inserted commented out

mix ash_postgres.generate_migrations –name add_category_on_delete_to_article
mix ash_postgres.migrate

# Delete Related Record Without Relying on Data Layer

The downside of this approach is that:
It won’t necessarily handle atomic/ transactional deletion, to ensure us that on success, all related records are deleted or nothing gets deleted on failure.
If delete references on the parent relationships are in the database, it might not propagate the deletion down childrens. For example: If we have a category with articles, and articles with comments. When a category is deleted, it should delete all its articles and comments related to the article. This is not guaranteed with this approach.

1. Remove :destroy from defaults. Your default should look like:
   defaults [:create, :read, :update]
2. Then manually add destroy action.

```
destroy :destroy do
  description "Destroy article and its comments"
  # Make this action primary so that it can be called with Ash.destroy without
  # having to mention the action to use
  primary? true
  require_atomic? false

  # Before this action is executed, we'll need to delete corresponding
  # comments
  change before_action(fn changeset, context ->
    # We need Ash.Query to filter
    require Ash.Query

    # Find all comments related to this article
    %Ash.BulkResult{status: :success} =
      Helpcenter.KnowledgeBase.Comment
      |> Ash.Query.filter(article_id == ^changeset.data.id)
      |> Ash.read!()
      #  Bulk delete all comments related to this article
      |> Ash.bulk_destroy(:destroy, _condition = %{}, batch_size: 100)


      # Continue with the change
      changeset
    end)
end
```

# Part 5 — Ash Framework For Phoenix Developers — Show Data on Pages & Ash Aggregations
