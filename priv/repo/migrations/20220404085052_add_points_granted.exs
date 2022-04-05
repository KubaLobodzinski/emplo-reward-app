defmodule EmploReward.Repo.Migrations.AddPointsGranted do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :points_granted, :integer, default: 0
    end
  end
end
