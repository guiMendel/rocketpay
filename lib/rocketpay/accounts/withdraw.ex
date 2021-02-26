defmodule Rocketpay.Accounts.Withdraw do
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(params) do
    params
    |> Operation.call(:withdraw)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    # faz um switch case de pattern matching
    case Repo.transaction(multi) do
      # como queremos realizar uma transacao atomica, ignoramos detalhes do erro
      # se algo deu erro, tudo deu erro
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{withdraw: account}} -> {:ok, account}
    end
  end
end
