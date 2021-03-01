defmodule Rocketpay.Users.Get do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id}) do
    case Repo.get(User, id) do
      %User{} = user -> {:ok, Repo.preload(user, :account)}
      nil -> {:error, %{message: "User not found", status: :not_found}}
    end
  end
end
