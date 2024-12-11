defmodule UkraineTaxidEx.Commons do
  @moduledoc """
  Common functions for UkraineTaxidEx.
  """

  @typedoc "A one digit of EDRPOU or ITIN it's non-negative integer from 0 to 9"
  @type digit :: non_neg_integer() | nil

  @typedoc "List of digits of EDRPOU or ITIN"
  @type digits :: [non_neg_integer()] | []

  @pad "0"

  @doc """
  Converts a string or integer to a list of digits.
  Takes a value and optional length parameter.
  When length is provided, pads the result with leading zeros.
  Returns list of digits as integers.

  ## Examples

      iex> UkraineTaxidEx.Commons.digits("123")
      [1, 2, 3]

      iex> UkraineTaxidEx.Commons.digits(123, 5)
      [0, 0, 1, 2, 3]

      iex> UkraineTaxidEx.Commons.digits("987", 5)
      [0, 0, 9, 8, 7]
  """
  @spec digits(value :: String.t() | integer, length :: non_neg_integer()) :: digits
  def digits(value, length \\ 0)
  def digits(value, length) when is_integer(value), do: digits("#{value}", length)

  def digits(value, length) when is_binary(value) do
    value
    |> clean()
    |> String.pad_leading(length, @pad)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  @spec check_digit(digits :: digits) :: digit
  def check_digit(digits), do: List.last(digits)

  @spec value_digits(digits :: digits) :: digits
  def value_digits(digits), do: Enum.take(digits, length(digits) - 1)

  @spec value_and_check_digits(digits :: digits) :: {digits, digit}
  def value_and_check_digits(digits), do: {value_digits(digits), check_digit(digits)}

  @spec clean(string :: String.t()) :: String.t()
  defp clean(string), do: String.replace(string, ~r/[^\d]/, "")

  def ok(data), do: {:ok, data}
  def error(error), do: {:error, error}
end
