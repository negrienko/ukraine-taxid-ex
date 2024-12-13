defmodule UkraineTaxidEx.Itin.Parser do
  @moduledoc """
  This module provides parsing functionality for Ukrainian Individual Taxpayer Identification Numbers (ITIN).

  ITINs (also known as РНОКПП/ІПН) are unique identifiers assigned to individuals in Ukraine for tax purposes.
  The parser validates the number format and extracts meaningful components like the checksum according to
  official requirements.

  Key features:
  - Validates ITIN format and length
  - Calculates and verifies checksum
  - Parses components into a structured format
  - Handles both raw strings and pre-validated input

  Examples of successful ITIN parsing:

  ```elixir
      iex> UkraineTaxidEx.Itin.Parser.parse("2222222222")
      {:ok, %UkraineTaxidEx.Itin{code: "2222222222", birth_date: ~D[1960-12-17], number: 2222, gender: 0, check_sum: 2, check_digit: 2}}

      iex> UkraineTaxidEx.Itin.Parser.parse("3333333333")
      {:ok, %UkraineTaxidEx.Itin{code: "3333333333", birth_date: ~D[1991-03-05], number: 3333, gender: 1, check_sum: 3, check_digit: 3}}
  ```

  Examples of unsuccessful ITIN parsing:

  ```elixir
      iex> UkraineTaxidEx.Itin.Parser.parse("123456")
      {:error, :length_too_short}

      iex> UkraineTaxidEx.Itin.Parser.parse("12345678901")
      {:error, :length_too_long}

      iex> UkraineTaxidEx.Itin.Parser.parse("1234567890")
      {:error, :invalid_checksum}
  ```
  """
  alias UkraineTaxidEx.Itin
  alias UkraineTaxidEx.Commons, as: C

  import UkraineTaxidEx.Itin, only: [length: 0]
  import UkraineTaxidEx.Itin.CheckSum, only: [check_sum: 1]
  import UkraineTaxidEx.Itin.Validator, only: [validate: 1]
  import UkraineTaxidEx.Commons, only: [check_digit: 1, digits: 1, digits: 3, undigits: 1, ok: 1]

  require Integer

  @type itin_string() :: String.t()
  @type itin() :: Itin.t()
  @type itin_or_error() ::
          {:ok, Itin.t()}
          | {:error,
             :length_too_short
             | :length_too_long
             | :invalid_checksum}

  @base_date Date.new!(1899, 12, 31)
  def base_date(), do: @base_date

  use UkraineTaxidEx.BaseParser

  defp generate({:ok, string}) do
    digits = digits(string)

    %{
      code: string,
      birth_date: birth_date(digits),
      number: number(digits),
      gender: gender(digits),
      check_sum: check_sum(digits),
      check_digit: check_digit(digits)
    }
    |> to_struct()
    |> ok()
  end

  @spec slice(digits :: C.digits(), Range.t()) :: Date.t()
  defp slice(digits, range) do
    digits
    |> Enum.slice(range)
    |> undigits()
    |> String.to_integer()
  end

  @spec birth_date(digits :: C.digits()) :: Date.t()
  def birth_date(digits), do: Date.add(base_date(), slice(digits, 0..4))

  @spec number(digits :: C.digits()) :: integer()
  def number(digits), do: slice(digits, 5..8)

  @spec gender(digits :: C.digits()) :: Itin.gender()
  def gender(digits), do: (Integer.is_odd(slice(digits, -2..-2//1)) && 1) || 0
end
