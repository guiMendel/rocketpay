defmodule Rocketpay.Repo.Migrations.OnDeleteUserDeleteAccount do
  use Ecto.Migration

  def up do
    # tira o constraint que ja existia
    execute "ALTER TABLE accounts DROP CONSTRAINT accounts_user_id_fkey"
    # cria um novo e altera para propagar adequadamente
    alter table :accounts do
      modify :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE accounts DROP CONSTRAINT accounts_user_id_fkey"
    alter table :accounts do
      modify :user_id, references(:users, type: :binary_id, on_delete: :nothing)
    end
  end
end
