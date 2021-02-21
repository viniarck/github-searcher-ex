defmodule GithubWeb.Router do
  use GithubWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", GithubWeb do
    pipe_through :api

    resources "/searches", SearchController, only: [:index, :show]
    resources "/repos/search", GhSearchController, only: [:create]
    resources "/repos", RepositoryController, only: [:index, :show]
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: GithubWeb.Telemetry
    end
  end
end
