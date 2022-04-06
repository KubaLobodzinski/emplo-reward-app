defmodule EmploReward.Repo.Migrations.AddRewardsHistory do
  use Ecto.Migration

  def change do
    create table(:rewards_history) do
      add :user_id, :integer
      add :reward_name, :string
      add :reward_cost, :integer

      timestamps()
    end
  end
end
