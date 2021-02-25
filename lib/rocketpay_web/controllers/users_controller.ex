defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  def create(connection, params) do
      params
      |> Rocketpay.create_user()
      |> handle_response(connection)
  end

  defp handle_response({:ok, %User{} = user}, connection) do
    connection
    |> put_status(:created)
    |> render("create.json", user: user)
  end

  defp handle_response({:error, result}, connection) do
    connection
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end

end
