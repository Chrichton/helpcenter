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
