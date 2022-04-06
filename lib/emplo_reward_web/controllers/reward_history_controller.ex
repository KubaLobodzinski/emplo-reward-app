defmodule EmploRewardWeb.RewardHistoryController do
  use EmploRewardWeb, :controller

  alias EmploReward.Rewards

  def user_history(conn, _params) do
    rewards = Rewards.get_rewards_history_by_user(conn.assigns.current_user.id)

    render conn, "user_history.html", rewards: rewards
  end

  def admin_history(conn, params) do
    if %{} == params do
      rewards = Rewards.list_rewards_history()

      render conn, "admin_history.html", rewards: rewards
    else
      rewards = Rewards.get_rewards_history_by_month(params)

      render conn, "admin_history.html", rewards: rewards
    end
  end

end
