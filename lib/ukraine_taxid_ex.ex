defmodule UkraineTaxidEx do
  @itin_length UkraineTaxidEx.Itin.length()
  @edrpou_length UkraineTaxidEx.Edrpou.length()

  @moduledoc """
  Documentation for `UkraineTaxidEx`.
  """

  @doc """
  `determine/1`: Takes a tax ID string and identifies its type based on length

  - Returns `{:ok, UkraineTaxidEx.Itin}` for ITIN numbers
  - Returns `{:ok, UkraineTaxidEx.Edrpou}` for EDRPOU numbers
  - Returns an error if the length is invalid
  """
  def determine(tax_id) when is_binary(tax_id) do
    case String.length(tax_id) do
      @itin_length -> {:ok, UkraineTaxidEx.Itin}
      @edrpou_length -> {:ok, UkraineTaxidEx.Edrpou}
      _ -> {:error, "Invalid tax ID length"}
    end
  end

  @doc """
  `parse/1`: Determines the tax ID type and parses it using the appropriate parser

  - Uses `Module.concat` to dynamically find the correct parser module
  - Returns a tuple with status, result, and type information
  """
  def parse(tax_id) do
    case determine(tax_id) do
      {:ok, type} ->
        parser = Module.concat(type, "Parser")
        {status, result} = parser.parse(tax_id)
        {status, result, type}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  `validate/1`: Validates a tax ID by attempting to parse it

  - Returns `:ok` if valid
  - Returns error tuples with details if invalid
  """

  def validate(tax_id) do
    case parse(tax_id) do
      {:ok, _, _} -> :ok
      {:error, error, type} -> {:error, error, type}
      {:error, error} -> {:error, error}
    end
  end
end
