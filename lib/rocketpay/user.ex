defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.Account

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :age, :email, :password, :nickname]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    # o campo virtual nao e salvo no BD
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    has_one :account, Account

    timestamps()
  end

  # changeset para novo usuario
  # mapeia (faz o cast certinho dos tipo de cada parametro) e valida dados para serem inseridos na tabela
  def changeset(struct \\ %__MODULE__{}, params) do
    # __MODULE__ é um alias para o modulo atual, nesse caso Rocketpay.User
    struct
    |> cast(params, @required_params)
    # a partir do cast, a struct vira um changeset
    |> validate_changeset(Map.get(struct, :id))
    |> put_password_hash()
  end

  defp validate_changeset(changeset, user_id) do
    result =
      changeset
      |> validate_length(:password, min: 6)
      |> validate_number(:age, greater_than_or_equal_to: 18)
      |> validate_format(:email, ~r/@/)
      |> unique_constraint([:email])
      |> unique_constraint([:nickname])

    # somente se o usuario nao existia nos verificamos se todos os params estao ai
    case user_id do
      nil -> validate_required(result, @required_params)
      _ -> result
    end
  end

  # fazemos pattern matching para pegar um argumento do tipo changeset valido
  # e extrair o campo password numa variável
  defp put_password_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password}
         } = changeset
       ) do
    # essa fn recebe um changeset e modifica seu campo "changes" com base no map que recebe
    change(changeset, Bcrypt.add_hash(password))
  end

  # se nao houver senha ou o changeset for invalido, so passa para frente
  defp put_password_hash(changeset), do: changeset
end
