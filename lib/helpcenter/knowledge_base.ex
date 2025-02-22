defmodule Helpcenter.KnowledgeBase do
  use Ash.Domain,
    otp_app: :helpcenter

  resources do
    resource Helpcenter.KnowledgeBase.Category
    resource Helpcenter.KnowledgeBase.Article
    resource Helpcenter.KnowledgeBase.Comment
  end
end
