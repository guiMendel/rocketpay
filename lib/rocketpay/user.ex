defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset

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

    timestamps()
  end

  # mapeia (faz o cast certinho dos tipo de cada parametro) e valida dados para serem inseridos na tabela
  def changeset(params) do
    # __MODULE__ é um alias para o modulo atual, nesse caso Rocketpay.User
    %__MODULE__{}
    |> cast(params, @required_params)
    # a partir do cast, a struct vira um changeset
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> put_password_hash()
  end

  # fazemos pattern matching para pegar um argumento do tipo changeset valido
  # e extrair o campo password numa variável
  defp put_password_hash(%Ecto.Changeset{
    valid?: true,
    changes: %{password: password}
  } = changeset) do
    # essa fn recebe um changeset e modifica seu campo "changes" com base no map que recebe
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
