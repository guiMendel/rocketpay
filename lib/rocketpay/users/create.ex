defmodule Rocketpay.Users.Create do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo, User}

  def call(params) do
    # esse modulo permite perparar um bundle de transacoes no BD
    # assim podemos garantir que se uma falha, todos falham, e nada fica pela metade!
    Multi.new()
    # cada uma das operacoes deve receber um nome
    |> Multi.insert(:create_user, User.changeset(params))
    # o run() faz operacoes assim como o Repo, mas permite acessar resutado de operacoes
    # passadas pelo seu nome
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user)
    end)
    |> run_transaction()

    # params
    # |> User.changeset()
    # |> Repo.insert()
  end

  defp insert_account(repo, user) do
    user.id
    # cria o changeset
    |> account_changeset()
    # insere no bd
    |> repo.insert()
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}
    Account.changeset(params)
  end

  defp run_transaction(multi) do
    # faz um switch case de pattern matching
    case Repo.transaction(multi) do
      # como queremos realizar uma transacao atomica, ignoramos detalhes do erro
      # se algo deu erro, tudo deu erro
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{create_account: account}} -> IO.inspect(account)
    end
  end
end
