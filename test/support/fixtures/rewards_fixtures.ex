defmodule EmploReward.RewardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmploReward.Rewards` context.
  """

  @doc """
  Generate a reward.
  """
  def reward_fixture(attrs \\ %{}) do
    {:ok, reward} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        point_cost: 42
      })
      |> EmploReward.Rewards.create_reward()

    reward
  end
end
