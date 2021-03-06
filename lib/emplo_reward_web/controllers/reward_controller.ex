defmodule EmploRewardWeb.RewardController do
  use EmploRewardWeb, :controller

  alias EmploReward.Rewards
  alias EmploReward.Rewards.Reward
  alias EmploReward.Accounts

  def index(conn, _params) do
    rewards = Rewards.list_rewards()
    render(conn, "index.html", rewards: rewards)
  end

  def admin_index(conn, _params) do
    rewards = Rewards.list_rewards()
    render(conn, "admin_rewards_list.html", rewards: rewards)
  end

  def new(conn, _params) do
    changeset = Rewards.change_reward(%Reward{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reward" => reward_params}) do
    case Rewards.create_reward(reward_params) do
      {:ok, _reward} ->
        conn
        |> put_flash(:info, "Reward created successfully.")
        |> redirect(to: Routes.reward_path(conn, :admin_index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    reward = Rewards.get_reward!(id)
    changeset = Rewards.change_reward(reward)
    render(conn, "edit.html", reward: reward, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reward" => reward_params}) do
    reward = Rewards.get_reward!(id)

    case Rewards.update_reward(reward, reward_params) do
      {:ok, _reward} ->
        conn
        |> put_flash(:info, "Reward updated successfully.")
        |> redirect(to: Routes.reward_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reward: reward, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reward = Rewards.get_reward!(id)
    {:ok, _reward} = Rewards.delete_reward(reward)

    conn
    |> put_flash(:info, "Reward deleted successfully.")
    |> redirect(to: Routes.reward_path(conn, :index))
  end

  ## User gets the reward, function checks if he/she has enough points, then it creates rewards_history entry and gives him a reward

  def grant_reward(conn, %{"reward_id" => id} = _attrs) do
    reward = Rewards.get_reward!(id)
    new_points_value = conn.assigns.current_user.points_granted - reward.point_cost
    entry = %{"user_id" => conn.assigns.current_user.id, "reward_name" => reward.name, "reward_cost" => reward.point_cost}
    user_params = %{"id" => conn.assigns.current_user.id, "points_granted" => new_points_value}

    case user_has_enough_points?(conn, reward) do
      true ->
        case Accounts.change_user_granted_points(user_params) do
          {:ok, _user} ->
            conn
            |> history_entry(entry)
            |> Accounts.UserNotifier.deliver_reward(conn.assigns.current_user, reward.name)
            |> put_flash(:info, "Reward granted! You will get an email with your reward soon.")
            |> redirect(to: Routes.reward_path(conn, :index))
          {:error, _} ->
            conn
            |> put_flash(:error, "Something went wrong.")
            |> redirect(to: Routes.reward_path(conn, :index))
        end
      false ->
        conn
        |> put_flash(:error, "Not enough points!")
        |> redirect(to: Routes.reward_path(conn, :index))
    end
  end

  defp user_has_enough_points?(conn, reward) do
    if conn.assigns.current_user.points_granted >= reward.point_cost do
      true
    else
      false
    end
  end

  defp history_entry(conn, entry) do
     Rewards.create_history_entry(entry)
     conn
  end

end
