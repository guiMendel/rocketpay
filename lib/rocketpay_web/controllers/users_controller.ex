defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  action_fallback RocketpayWeb.FallbackController

  def create(connection, params) do
    # faz pattern matching com o resultado da expressao na direita
    # se falhar, retorna o resultado, e como ele eh o retorno dessa funcao,
    # a funcao retorna o erro, e ele cai no fallback
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do
      connection
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def index(connection, _params) do
    with {:ok, users} <- Rocketpay.index_users() do
      connection
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def get(connection, params) do
    with {:ok, %User{} = user} <- Rocketpay.get_user(params) do
      connection
      |> put_status(:ok)
      |> render("get.json", user: user)
    end
  end

  def update(connection, params) do
    with {:ok, %User{} = user} <- Rocketpay.update_user(params) do
      connection
      |> put_status(:ok)
      |> render("update.json", user: user)
    end
  end

  def delete(connection, params) do
    with {:ok, _result} <- Rocketpay.delete_user(params) do
      connection
      |> put_status(:no_content)
      |> text("")
    end
  end
end
