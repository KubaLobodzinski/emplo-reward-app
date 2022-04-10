defmodule EmploRewardWeb.RewardControllerTest do
  use EmploRewardWeb.ConnCase

  import EmploReward.RewardsFixtures
  import EmploReward.AccountsFixtures

  alias EmploRewardWeb.UserRegistrationController
  alias EmploRewardWeb.UserAuth
  alias EmploReward.Accounts


  @create_attrs %{description: "some description", name: "some name", point_cost: 42}
  @update_attrs %{description: "some updated description", name: "some updated name", point_cost: 43}
  @invalid_attrs %{description: nil, name: nil, point_cost: nil}


  #setup [:create_user, :login_as_registered_user]

  def create_user(_) do
    user = user_fixture()
    {:ok, user: user}
  end

  def login_as_registered_user(%{conn: conn, user: user}) do
    conn = UserAuth.log_in_user(build_conn(), user)
    {:ok, conn: conn}
  end


  # setup%{conn: conn} do
  #   conn = assign(conn, :current_user, user_fixture())
  #   #user = UserRegistrationController.create(conn, %{"user" => %{"email" => "email@email.com", "password" => "password", "full_name" => "Jakub Łobodziński", "role" => "member"}})
  #   %{conn: conn}
  # end

  describe "index" do
  setup [:create_user, :login_as_registered_user]
    test "lists all rewards", %{conn: conn} do
      IO.puts("+++")
      IO.puts("+++")
      IO.inspect(conn)
      conn = get(conn, Routes.reward_path(conn, :index))
     # |> post(UserRegistrationController.create(conn, %{"user" => %{"email" => "email@email.com", "password" => "password", "full_name" => "Jakub Łobodziński", "role" => "member"}}))

      assert html_response(conn, 200) =~ "Available Rewards"
    end
  end

  describe "new reward" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.reward_path(conn, :new))
      assert html_response(conn, 200) =~ "New Reward"
    end
  end

  describe "create reward" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.reward_path(conn, :create), reward: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.reward_path(conn, :show, id)

      conn = get(conn, Routes.reward_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Reward"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post(conn, Routes.reward_path(conn, :create), reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Reward"
    end
  end

  describe "edit reward" do
    setup [:create_reward]

    test "renders form for editing chosen reward", %{conn: conn, reward: reward, user: user} do
      conn = get(conn, Routes.reward_path(conn, :edit, reward))
      assert html_response(conn, 200) =~ "Edit Reward"
    end
  end

  describe "update reward" do
    setup [:create_reward]

    test "redirects when data is valid", %{conn: conn, reward: reward} do
      conn = put(conn, Routes.reward_path(conn, :update, reward), reward: @update_attrs)
      assert redirected_to(conn) == Routes.reward_path(conn, :admin_index)
    end

    test "renders errors when data is invalid", %{conn: conn, reward: reward} do
      conn = put(conn, Routes.reward_path(conn, :update, reward), reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Reward"
    end
  end

  describe "delete reward" do
    setup [:create_reward]

    test "deletes chosen reward", %{conn: conn, reward: reward} do
      conn = delete(conn, Routes.reward_path(conn, :delete, reward))
      assert redirected_to(conn) == Routes.reward_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.reward_path(conn, :show, reward))
      end
    end
  end

  defp create_reward(_) do
    reward = reward_fixture()
    %{reward: reward}
  end
end
