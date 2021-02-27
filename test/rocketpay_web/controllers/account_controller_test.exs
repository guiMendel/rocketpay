defmodule RocketpayWeb.AccountsControllerTest do
  # o async true faz rodar em paralelo
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    # precisa de um contexto para realizar os testes
    setup %{conn: connection} do
      params = %{
        name: "Jorjinho",
        password: "123456",
        nickname: "j0rg",
        email: "jorginho@maniero.edu",
        age: 21
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      # adiciona o header de autenticacao
      # o valor de autorizaocao eh "Basic username:password", mas codificado em Base64
      connection = put_req_header(connection, "authorization", "Basic cGlyYXRhOmFob3k=")

      # no final do setup, sempre deve retornar uma tupla com :ok e os params q vamos usar nos testes
      {:ok, connection: connection, account_id: account_id}
    end

    # apos o nome do teste podemos escolher os parametros que vamos usar no teste
    test "when all params are valid, receives confirmation", %{
      connection: connection,
      account_id: account_id
    } do
      params = %{"value" => "50.00"}

      response =
        connection
        # usa um helper introduzido pelo RocketpayWeb.ConnCase
        |> post(Routes.accounts_path(connection, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "balance" => "50.00",
                 "id" => ^account_id
               },
               "message" => "Balance updated successfully"
             } = response
    end

    # apos o nome do teste podemos escolher os parametros que vamos usar no teste
    test "when value param is invalid, receives an error", %{
      connection: connection,
      account_id: account_id
    } do
      params = %{"value" => "jooj"}

      response =
        connection
        # usa um helper introduzido pelo RocketpayWeb.ConnCase
        |> post(Routes.accounts_path(connection, :deposit, account_id, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid deposit value"} = response
    end
  end
end
