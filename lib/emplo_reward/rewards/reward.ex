defmodule EmploReward.Rewards.Reward do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rewards" do
    field :description, :string
    field :name, :string
    field :point_cost, :integer

    timestamps()
  end

  @doc false
  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:name, :description, :point_cost])
    |> validate_required([:name, :description, :point_cost])
  end
end
