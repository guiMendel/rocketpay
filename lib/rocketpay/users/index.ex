defmodule Rocketpay.Users.Index do
  alias Rocketpay.{Repo, User}

  def call() do
    response =
      User
      # pega os usuarios
      |> Repo.all()
      # carrega suas contas
      |> Enum.map(fn user -> Repo.preload(user, :account) end)

    {:ok, response}
  end
end
