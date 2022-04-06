defmodule EmploRewardWeb.UserAddPointsController do
  use EmploRewardWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  alias EmploReward.Accounts

  def add(conn, %{"user" => %{"points_granted" => points, "id" => id} = user_params}) do
   points_all = (String.to_integer(points) + Accounts.get_user!(id).points_granted)
   user_params = %{user_params | "points_granted" => Integer.to_string(points_all), "id" => String.to_integer(id)}
   points_left = conn.assigns.current_user.points - String.to_integer(points)

   current_user_params = %{"id" => conn.assigns.current_user.id, "points" => points_left}

    case Accounts.change_user_granted_points(user_params) do
      {:ok, _} ->
        Accounts.change_user_points(current_user_params)

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
