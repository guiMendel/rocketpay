defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias RocketpayWeb.UsersView
  alias Rocketpay.{Account, User}

  setup %{conn: connection} do
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
    {:ok, %User{} = user1} = Rocketpay.create_user(params1)

    {:ok, %User{} = user2} = Rocketpay.create_user(params2)

    # adiciona o header de autenticacao
    # o valor de autorizaocao eh "Basic username:password", mas codificado em Base64
    connection = put_req_header(connection, "authorization", "Basic cGlyYXRhOmFob3k=")

    # no final do setup, sempre deve retornar uma tupla com :ok e os params q vamos usar nos testes
    {:ok, connection: connection, params: [params1, params2], users: [user1, user2]}
  end

  # como o teste de view eh mais simples, n precisa do describe
  test "renders create.json", %{
    users: [%User{id: user_id, account: %Account{id: account_id}} = user, _user2]
  } do
    # o Phoenix.View da acesso aos renders
    response = render(UsersView, "create.json", user: user)

    assert %{
             message: "User created",
             user: %{
               account: %{id: ^account_id},
               id: ^user_id,
               name: "Jorjinho",
               nickname: "j0rg"
             }
           } = response
  end

  test "renders index.json", %{
    users:
      [
        %User{id: user1_id, account: %Account{id: account1_id}},
        %User{id: user2_id, account: %Account{id: account2_id}}
      ] = users
  } do
    # o Phoenix.View da acesso aos renders
    response = render(UsersView, "index.json", users: users)

    assert [
             %{
               account: %{
                 id: ^account1_id
               },
               name: "Jorjinho",
               nickname: "j0rg",
               email: "jorginho@maniero.edu",
               age: 21,
               id: ^user1_id
             },
             %{
               account: %{
                 id: ^account2_id
               },
               name: "Armandinho",
               nickname: "armands",
               email: "armands@maniero.edu",
               age: 25,
               id: ^user2_id
             }
           ] = response
  end

  test "renders get.json", %{
    users: [%User{id: user_id, account: %Account{id: account_id}} = user, _user2]
  } do
    response = render(UsersView, "get.json", user: user)

    assert %{
             account: %{id: ^account_id},
             id: ^user_id,
             name: "Jorjinho",
             nickname: "j0rg"
           } = response
  end

  test "renders update.json", %{
    users: [%User{id: user_id, account: %Account{id: account_id}} = user, _user2]
  } do
    # o Phoenix.View da acesso aos renders
    response = render(UsersView, "update.json", user: user)

    assert %{
             message: "User updated",
             user: %{
               account: %{id: ^account_id},
               id: ^user_id,
               name: "Jorjinho",
               nickname: "j0rg"
             }
           } = response
  end
end
