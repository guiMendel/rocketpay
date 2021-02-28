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

  test "renders index.json" do
    # cria os params
    params1 = %{
      name: "Jorjinho",
      password: "123456",
      nickname: "j0rg",
      email: "jorginho@maniero.edu",
      age: 21
    }

    params2 = %{
      name: "Armandinho",
      password: "123456",
      nickname: "armands",
      email: "armands@maniero.edu",
      age: 25
    }

    # cria eles e pega os ids
    {:ok, %User{id: user_id1, account: %Account{id: account_id1}} = user1} =
      Rocketpay.create_user(params1)

    {:ok, %User{id: user_id2, account: %Account{id: account_id2}} = user2} =
      Rocketpay.create_user(params2)

    # o Phoenix.View da acesso aos renders
    response = render(UsersView, "index.json", users: [user1, user2])

    assert [
      %{
        account: %{
          id: ^account_id1
        },
        name: "Jorjinho",
        nickname: "j0rg",
        email: "jorginho@maniero.edu",
        age: 21,
        id: ^user_id1
      },
      %{
        account: %{
          id: ^account_id2
        },
        name: "Armandinho",
        nickname: "armands",
        email: "armands@maniero.edu",
        age: 25,
        id: ^user_id2
      }
    ] = response
  end
end
