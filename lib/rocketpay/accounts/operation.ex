defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{"id" => id, "value" => value}, operation) do
    Multi.new()
    # verifica se a conta existe
    |> Multi.run(:account, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value, operation)
    end)
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> execute_operation(value, operation)
    |> update_account(repo, account)
  end

  defp execute_operation(%Account{balance: balance}, value, operation) do
    value
    # verifica a validez do valor
    # a lib decimal e boa pra isso e vem junto com ecto
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(sum, repo, account) do
    # cria o changeset para atualizar o BD
    params = %{balance: sum}

    account
    |> Account.changeset(params)
    |> repo.update()
  end
end
