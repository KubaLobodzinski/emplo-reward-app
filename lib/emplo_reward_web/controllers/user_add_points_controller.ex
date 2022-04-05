defmodule EmploRewardWeb.UserAddPointsController do
  use EmploRewardWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  alias EmploReward.Accounts

  def add(conn, %{"user" => %{"points_granted" => points, "id" => id} = user_params}) do
   points_all = (String.to_integer(points) + Accounts.get_user!(id).points_granted)
   user_params = %{user_params | "points_granted" => Integer.to_string(points_all)}
    case Accounts.add_points_to_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Points succesfully granted!")
        |> redirect(to: "/")
      {:error, _message} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end
end
