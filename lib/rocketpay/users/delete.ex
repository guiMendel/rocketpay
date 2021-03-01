defmodule Rocketpay.Users.Delete do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id}) do
    Repo.get(User, id)
    |> Repo.delete()
  end
end
