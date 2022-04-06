defmodule EmploReward.Rewards.RewardHistory do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "rewards_history" do
    field :user_id, :integer
    field :reward_name, :string
    field :reward_cost, :integer

    timestamps()
  end

  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:user_id, :reward_name, :reward_cost])
    |> validate_required([:user_id, :reward_name, :reward_cost])
  end

  def search_by_month(query, search_term) do
    search_term = String.to_integer(search_term)

    from reward in query,
    where: fragment("date_part('month', ?)", reward.inserted_at) == ^search_term
  end

  def search_by_user(query, search_term) do
    from reward in query,
    where: reward.user_id == ^search_term
  end

end
