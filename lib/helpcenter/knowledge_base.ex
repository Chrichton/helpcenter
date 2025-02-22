defmodule Helpcenter.KnowledgeBase do
  use Ash.Domain,
    otp_app: :helpcenter

  resources do
    resource Helpcenter.KnowledgeBase.Category
  end
end
