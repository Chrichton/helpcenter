defmodule Helpcenter.Accounts.Permission do
  use Ash.Resource,
    domain: Helpcenter.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "permissions"
    repo Helpcenter.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:action, :resource]
  end

  attributes do
    uuid_v7_primary_key :id
    # e.g., "read"
    attribute :action, :string, allow_nil?: false
    # e.g., "category"
    attribute :resource, :string, allow_nil?: false
    timestamps()
  end
end
