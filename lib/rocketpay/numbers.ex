defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
      |> File.read
      |> handle_file
  end

  defp handle_file({:ok, file}) do
    result = file
      |> String.split(",")
      |> Stream.map(fn n -> String.to_integer(n) end)
      |> Enum.sum

    {:ok, %{ result: result }}
  end

  defp handle_file({:error, _reason}), do: {:error, %{ message: "invalid file!" }}
end
