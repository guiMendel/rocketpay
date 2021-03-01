defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    # verifica se a conta existe
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)
      update_balance(repo, account, value, operation)
    end)
  end

  defp get_account(repo, id) do
    IO.puts(repo)

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

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, Decimal.abs(value))
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, Decimal.abs(value))
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(sum, repo, account) do
    # cria o changeset para atualizar o BD
    params = %{balance: sum}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}"
    |> String.to_atom()
  end
end
