defmodule EmploReward.Repo do
  use Ecto.Repo,
    otp_app: :emplo_reward,
    adapter: Ecto.Adapters.Postgres
end
