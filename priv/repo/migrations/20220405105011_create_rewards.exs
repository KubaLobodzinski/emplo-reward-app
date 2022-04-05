defmodule EmploReward.Repo.Migrations.CreateRewards do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :name, :string
      add :description, :string
      add :point_cost, :integer

      timestamps()
    end
  end
end
