defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate
  alias Rocketpay.Users.Index, as: UserIndex
  alias Rocketpay.Accounts.{Deposit, Withdraw, Transaction}

  # CRUD Facade
  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate index_users(), to: UserIndex, as: :call

  # Account operations
  defdelegate deposit(params), to: Deposit, as: :call

  defdelegate withdraw(params), to: Withdraw, as: :call

  defdelegate transaction(params), to: Transaction, as: :call
end
