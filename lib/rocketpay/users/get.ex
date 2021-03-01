defmodule Rocketpay.Users.Get do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id}) do
    case Repo.get(User, id) do
      %User{} = user -> {:ok, Repo.preload(user, :account)}
      nil -> {:error, "User not found"}
    end
  end
end
