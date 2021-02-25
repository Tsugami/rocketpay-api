defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(%{"from_id" => from_id, "to_id" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
      |> Multi.merge(fn _changes -> withdraw_params |> Operation.call(:withdraw) end)
      |> Multi.merge(fn _changes -> deposit_params |> Operation.call(:deposit) end)
      |> run_transaction
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, %{to_account: to_account, from_account: from_account}}
    end
  end

end
