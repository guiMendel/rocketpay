defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  import Plug.BasicAuth

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    # configura os dominios autorizados a utilizar os recursos dessa api
    # as this is as hobby project, any domain will be allowed to access it's resources
  end

  pipeline :auth do
    plug :basic_auth, Application.compile_env(:rocketpay, :basic_auth)
  end

  # rotas nao autenticadas
  scope "/api", RocketpayWeb do
    pipe_through :api

    # lida com preflighted requests
    options "/users", UsersController, :options

    # lida com preflighted requests
    options "/users/:id", UsersController, :options

    post "/users", UsersController, :create

    get "/users", UsersController, :index

    get "/users/:id", UsersController, :get

    # o id vem no corpo
    put "/users", UsersController, :update

    delete "/users/:id", UsersController, :delete
  end

  # rotas autenticadas
  scope "/api", RocketpayWeb do
    pipe_through [:api, :auth]

    # lida com preflighted requests
    options "/accounts/:id/deposit", AccountsController, :options

    # lida com preflighted requests
    options "/accounts/:id/withdraw", AccountsController, :options

    # lida com preflighted requests
    options "/accounts/transaction", AccountsController, :options

    post "/accounts/:id/deposit", AccountsController, :deposit

    post "/accounts/:id/withdraw", AccountsController, :withdraw

    post "/accounts/transaction", AccountsController, :transaction
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
    end
  end
end
