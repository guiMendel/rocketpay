defmodule Rocketpay.Accounts.Deposit do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    # verifica se a conta existe
    |> Multi.run(:account, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value)
    end)
    |> run_transaction()
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    account
    |> sum_values(value)
    |> update_account(repo, account)
  end

  defp sum_values(%Account{balance: balance}, value) do
    value
    # verifica a validez do valor
    # a lib decimal e boa pra isso e vem junto com ecto
    |> Decimal.cast()
    |> handle_cast(balance)
  end

  defp handle_cast({:ok, value}, balance), do: Decimal.add(value, balance)
  defp handle_cast(:error, _balance), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(sum, repo, account) do
    # cria o changeset para atualizar o BD
    params = %{balance: sum}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    # faz um switch case de pattern matching
    case Repo.transaction(multi) do
      # como queremos realizar uma transacao atomica, ignoramos detalhes do erro
      # se algo deu erro, tudo deu erro
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: account}} -> {:ok, account}
    end
  end
end
