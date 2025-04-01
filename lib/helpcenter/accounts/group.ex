defmodule Helpcenter.Accounts.Group do
  use Ash.Resource,
    domain: Helpcenter.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "groups"
    repo Helpcenter.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :description]
  end

  multitenancy do
    # Groups belong to a tenant
    strategy :context
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :description, :string, allow_nil?: false
    timestamps()
  end
end
