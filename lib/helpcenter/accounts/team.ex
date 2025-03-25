defmodule Helpcenter.Accounts.Team do
  use Ash.Resource,
    domain: Helpcenter.Accounts,
    data_layer: AshPostgres.DataLayer

  @doc """
  Tell Ash to use the domain as the tenant database prefix when using PostgreSQL as the database; otherwise, use the ID.
  """
  defimpl Ash.ToTenant do
    def to_tenant(resource, %{:domain => domain, :id => id}) do
      if Ash.Resource.Info.data_layer(resource) == AshPostgres.DataLayer &&
           Ash.Resource.Info.multitenancy_strategy(resource) == :context do
        domain
      else
        id
      end
    end
  end

  postgres do
    table "teams"
    repo Helpcenter.Repo

    manage_tenant do
      template ["", :domain]
      create? true
      update? false
    end
  end

  actions do
    default_accept [:name, :domain, :description]
    defaults [:create, :read]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :domain, :string, allow_nil?: false, public?: true
    attribute :description, :string, allow_nil?: true, public?: true

    timestamps()
  end

  relationships do
    belongs_to :owner, Helpcenter.Accounts.User do
      source_attribute :owner_user_id
    end

    many_to_many :users, Helpcenter.Accounts.User do
      through Helpcenter.Accounts.UserTeam
      source_attribute_on_join_resource :team_id
      destination_attribute_on_join_resource :user_id
    end
  end
end
