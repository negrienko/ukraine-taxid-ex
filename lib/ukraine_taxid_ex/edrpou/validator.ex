defmodule UkraineTaxidEx.Edrpou.Validator do
  @moduledoc """
  Functions for validating EDRPOU number format and checksum.

  This module provides validation functions to verify if an EDRPOU number meets the standard requirements including length and checksum validation.

  Validates an EDRPOU number to check if it meets length requirements and has a valid checksum.

  Returns:
   * `{:ok, edrpou}` if validation successful
   * `{:error, :length_too_short}` if shorter than required length
   * `{:error, :length_too_long}` if longer than required length
   * `{:error, :invalid_checksum}` if checksum is invalid

   ## Examples

   ```elixir
      iex> UkraineTaxidEx.Edrpou.Validator.validate("00032112")
      {:ok, "00032112"}

      iex> UkraineTaxidEx.Edrpou.Validator.validate("0003211")
      {:error, :length_too_short}

      iex> UkraineTaxidEx.Edrpou.Validator.validate("000321122")
      {:error, :length_too_long}

      iex> UkraineTaxidEx.Edrpou.Validator.validate("00032113")
      {:error, :invalid_checksum}
  ```
  """
  import UkraineTaxidEx.Edrpou, only: [length: 0]
  import UkraineTaxidEx.Edrpou.CheckSum, only: [check_sum: 1]

  use UkraineTaxidEx.BaseValidator
end
