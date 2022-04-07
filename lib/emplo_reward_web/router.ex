defmodule EmploRewardWeb.Router do
  use EmploRewardWeb, :router

  import EmploRewardWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EmploRewardWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EmploRewardWeb do
    pipe_through [:browser, :require_authenticated_user, :redirect_if_user_is_admin]

    get "/", UserMainPageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmploRewardWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EmploRewardWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EmploRewardWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", EmploRewardWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", EmploRewardWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  ## Points routes

  scope "/", EmploRewardWeb do
    pipe_through [:browser, :require_authenticated_user, :redirect_if_user_is_admin]

    post "/users/add_points", UserAddPointsController, :add
    get "/rewards", RewardController, :index
    get "/:reward_id/get_reward", RewardController, :grant_reward
    get "/rewards/history", RewardHistoryController, :user_history

    end

    scope "/", EmploRewardWeb do
      pipe_through [:browser, :require_admin_user]
      get "/rewards/admin_list", RewardController, :admin_index
      get "/rewards/:id/edit", RewardController, :edit
      get "/rewards/new", RewardController, :new
      post "/rewards", RewardController, :create
      patch "/rewards/:id", RewardController, :update
      put "/rewards/:id", RewardController, :update
      delete "/rewards/:id", RewardController, :delete
      get "/rewards/history/admin", RewardHistoryController, :admin_history
    end

end
