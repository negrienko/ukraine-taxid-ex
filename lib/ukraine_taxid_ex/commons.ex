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
  Normalizes the input value to a string of the specified length.
  Takes a value and required length parameter.
  Pads the result with leading zeros.
  Returns a string.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.normalize(123, 5)
      "00123"

      iex> UkraineTaxidEx.Commons.normalize("987", 5)
      "00987"
  ```
  """
  def normalize(value, length) do
    value
    |> digits(length)
    |> undigits()
  end

  @doc """
  Converts a string or integer to a list of digits.
  Takes a value and optional length and clean parameters.
  When length is provided, pads the result with leading zeros.
  When clean is true, remove all non digit character from string.
  Returns list of digits as integers.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.digits("123")
      [1, 2, 3]

      iex> UkraineTaxidEx.Commons.digits(123, 5)
      [0, 0, 1, 2, 3]

      iex> UkraineTaxidEx.Commons.digits("987", 5)
      [0, 0, 9, 8, 7]
  ```
  """
  @spec digits(value :: String.t() | integer, length :: non_neg_integer(), clean? :: boolean()) ::
          digits
  def digits(value, length \\ 0, clean? \\ false)
  def digits(value, length, _clean?) when is_integer(value), do: digits("#{value}", length, false)

  def digits(value, length, clean?) when is_binary(value) do
    value
    |> then(fn v -> (clean? && clean(v)) || v end)
    |> String.pad_leading(length, @pad)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Converts list of digits to a string.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.undigits([1, 2, 3])
      "123"
  ```
  """
  @spec undigits(digits :: digits) :: String.t()
  def undigits(digits), do: Enum.join(digits)

  @doc """
  Gets the check digit (last digit) from a list of digits.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.check_digit([1, 2, 3, 4])
      4
  ```
  """
  @spec check_digit(digits :: digits) :: digit
  def check_digit(digits), do: List.last(digits)

  @doc """
  Gets all digits except the check digit from a list of digits.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.value_digits([1, 2, 3, 4])
      [1, 2, 3]
  ```
  """
  @spec value_digits(digits :: digits) :: digits
  def value_digits(digits), do: Enum.take(digits, length(digits) - 1)

  @doc """
  Splits a list of digits into value digits and check digit.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.value_and_check_digits([1, 2, 3, 4])
      {[1, 2, 3], 4}
  ```
  """
  @spec value_and_check_digits(digits :: digits) :: {value_digits :: digits, check_digit :: digit}
  def value_and_check_digits(digits), do: {value_digits(digits), check_digit(digits)}

  @doc """
  Return digits and check digit separatly in one tuple.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.digits_and_check_digit([1, 2, 3, 4])
      {[1, 2, 3, 4], 4}
  ```
  """
  @spec digits_and_check_digit(digits :: digits) :: {value_digits :: digits, check_digit :: digit}
  def digits_and_check_digit(digits), do: {digits, check_digit(digits)}

  @spec clean(string :: String.t()) :: String.t()
  defp clean(string), do: String.replace(string, ~r/[^\d]/, "")

  @doc """
  Wraps data in an :ok tuple.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.ok("data")
      {:ok, "data"}
  ```
  """
  @spec ok(data :: any()) :: {:ok, any()}
  def ok(data), do: {:ok, data}

  @doc """
  Wraps error in an :error tuple.

  ## Examples

  ```elixir
      iex> UkraineTaxidEx.Commons.error("error")
      {:error, "error"}
  ```
  """
  @spec error(error :: any()) :: {:error, any()}
  def error(error), do: {:error, error}
end
