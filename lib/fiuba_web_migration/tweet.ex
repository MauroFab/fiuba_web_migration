defmodule FiubaWebMigration.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :author_id, :integer
    field :likes, :integer
    field :text, :string
    field :replied_tweet_id, :integer
    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:text, :likes, :author_id, :replied_tweet_id])
    |> validate_required([:text, :likes, :author_id])
  end
end
