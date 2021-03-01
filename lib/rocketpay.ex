defmodule Rocketpay do
  alias Rocketpay.Users
  alias Rocketpay.Accounts.{Deposit, Withdraw, Transaction}

  # CRUD Facade
  defdelegate create_user(params), to: Users.Create, as: :call

  defdelegate index_users(), to: Users.Index, as: :call

  defdelegate get_user(params), to: Users.Get, as: :call

  defdelegate update_user(params), to: Users.Update, as: :call

  defdelegate delete_user(params), to: Users.Delete, as: :call

  # Account operations
  defdelegate deposit(params), to: Deposit, as: :call

  defdelegate withdraw(params), to: Withdraw, as: :call

  defdelegate transaction(params), to: Transaction, as: :call
end
