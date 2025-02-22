defmodule Helpcenter.KnowledgeBase.Category do
  use Ash.Resource,
    otp_app: :helpcenter,
    domain: Helpcenter.KnowledgeBase,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "categories"
    repo Helpcenter.Repo
  end
end
