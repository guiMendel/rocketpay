defmodule Rocketpay.Users.CreateTest do
  alias Rocketpay.User
  alias Rocketpay.Users.Create
  # alem de fornecer algumas funcoes uteis, cria um sandbox do ecto no ambiente de teste
  # esse sandbox garante que todas as operacoes de BD, uma vez concluidos os tetes, serao descartadas num rollback
  use Rocketpay.DataCase, async: true

  describe "call/1" do
    test "when all params are valid, returns a user" do
      # cria os params
      params = %{
        name: "Jorjinho",
        password: "123456",
        nickname: "j0rg",
        email: "jorginho@maniero.edu",
        age: 21
      }

      # cria e pega o id
      {:ok, %User{id: user_id}} = Create.call(params)

      # verifica se ele esta no banco
      user = Repo.get(User, user_id)

      # o ^ pega o valor da variavel e o usa no pattern matching, em vez de atribuir para a variavel
      assert %User{name: "Jorjinho", age: 21, id: ^user_id} = user
    end

    test "when any param is invalid, returns an error" do
      # cria os params
      params = %{
        name: "Jorjinho",
        nickname: "j0rg",
        email: "jorginho@maniero.edu",
        age: 16
      }

      # cria e pega o id
      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      # errors_on eh funcao do Rocketpay.DataCase
      assert expected_response == errors_on(changeset)
    end
  end
end
