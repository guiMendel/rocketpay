# lida com os erros levantados pelos outros controllers
defmodule RocketpayWeb.FallbackController do
  use RocketpayWeb, :controller

  def call(connection, {:error, %{message: result, status: status}}) do
    connection
    |> put_status(status)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(connection, {:error, result}),
    do: call(connection, {:error, %{message: result, status: :bad_request}})
end
