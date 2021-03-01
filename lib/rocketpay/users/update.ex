defmodule Rocketpay.Users.Update do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
      %User{} = user -> update_user(user, params)
      nil -> {:error, "User not found"}
    end
  end

  defp update_user(user, params) do
    user
    |> User.changeset(params)
    # aplica
    |> Repo.update()
    # carrega a conta
    |> preload_account()
  end

  defp preload_account({:ok, user}), do: {:ok, Repo.preload(user, :account)}
  defp preload_account(e), do: e
end
