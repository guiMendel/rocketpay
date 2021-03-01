defmodule RocketpayWeb.UsersView do
  alias Rocketpay.{User, Account}

  def render(
        "get.json",
        %{
          user: %User{
            id: id,
            name: name,
            nickname: nickname,
            email: email,
            age: age,
            account: %Account{
              id: account_id,
              balance: balance
            }
          }
        }
      ) do
    %{
      id: id,
      name: name,
      nickname: nickname,
      email: email,
      age: age,
      account: %{
        id: account_id,
        balance: balance
      }
    }
  end

  def render("create.json", params) do
    render("get.json", params)
    |> append_message("User created")
  end

  def render("update.json", params) do
    render("get.json", params)
    |> append_message("User updated")
  end

  def render("index.json", %{users: users}) do
    users
    |> Enum.map(fn %User{
                     id: id,
                     name: name,
                     email: email,
                     nickname: nickname,
                     age: age,
                     account: %Account{
                       id: account_id,
                       balance: balance
                     }
                   } ->
      %{
        id: id,
        name: name,
        nickname: nickname,
        email: email,
        age: age,
        account: %{
          id: account_id,
          balance: balance
        }
      }
    end)
  end

  defp append_message(%{} = user, message), do: %{user: user, message: message}
end
