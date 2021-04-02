defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Account

  action_fallback RocketpayWeb.FallbackController

  def deposit(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.deposit(params) do
      connection
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
      connection
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(connection, params) do
    with {:ok, %TransactionResponse{} = transaction} <- Rocketpay.transaction(params) do
      connection
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end

  # preflighted requests
  def options(connection, _params) do
    connection
    |> put_status(:no_content)
    |> text("")
  end
end
