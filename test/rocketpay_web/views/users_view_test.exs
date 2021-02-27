defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias RocketpayWeb.UsersView
  alias Rocketpay.{Account, User}

  # como o teste de view eh mais simples, n precisa do describe
  test "renders create.json" do
    # cria os params
    params = %{
      name: "Jorjinho",
      password: "123456",
      nickname: "j0rg",
      email: "jorginho@maniero.edu",
      age: 21
    }

    # cria e pega o id do usuario e de sua conta
    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    # o Phoenix.View da acesso aos renders
    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{balance: Decimal.new("0.00"), id: account_id},
        id: user_id,
        name: "Jorjinho",
        nickname: "j0rg"
      }
    }

    assert expected_response == response
  end
end
