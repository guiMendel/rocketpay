defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Account

  def render("update.json", %{account: %Account{id: id, balance: balance}}) do
    %{
      message: "Balance updated successfully",
      account: %{
        id: id,
        balance: balance
      }
    }
  end

  def render("transaction.json", %{
        transaction: %TransactionResponse{to_account: to_account, from_account: from_account}
      }) do
    %{
      message: "Transaction executed successfully",
      transaction: %{
        to_account: %{id: to_account.id, balance: to_account.balance},
        from_account: %{id: from_account.id, balance: from_account.balance}
      }
    }
  end
end
