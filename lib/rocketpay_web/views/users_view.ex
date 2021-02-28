defmodule RocketpayWeb.UsersView do
  alias Rocketpay.{User, Account}

  def render("create.json", %{
        user: %User{
          id: id,
          name: name,
          nickname: nickname,
          account: %Account{
            id: account_id,
            balance: balance
          }
        }
      }) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        nickname: nickname,
        account: %{
          id: account_id,
          balance: balance
        }
      }
    }
  end

  def render("index.json", %{users: users}) do
    users
    # |> IO.inspect()
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
end
