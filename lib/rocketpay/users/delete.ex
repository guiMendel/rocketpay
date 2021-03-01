defmodule Rocketpay.Users.Delete do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id}) do
    case Repo.get(User, id) do
      %User{} = user -> Repo.delete(user)
      nil -> {:error, %{message: "User not found", status: :not_found}}
    end
  end
end
