defmodule EmploRewardWeb.UserMainPageController do
  use EmploRewardWeb, :controller

  alias EmploReward.Accounts
  alias EmploReward.Accounts.User



  def index(conn, _params) do
    users = Accounts.get_all_users()
    changeset = User.points_changeset(%User{})
    render conn, "index.html", users: users, changeset: changeset
  end

end
