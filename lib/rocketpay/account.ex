defmodule Rocketpay.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User

    timestamps()
  end

  # mapeia (faz o cast certinho dos tipo de cada parametro) e valida dados para serem inseridos na tabela
  def changeset(params) do
    # __MODULE__ é um alias para o modulo atual, nesse caso Rocketpay.User
    %__MODULE__{}
    |> cast(params, @required_params)
    # a partir do cast, a struct vira um changeset
    |> validate_required(@required_params)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
