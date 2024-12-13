defmodule UkraineTaxidEx.Itin.Validator do
  @moduledoc """
  Validator module for Ukrainian Individual Taxpayer Identification Number (ITIN/IPN).
  Handles validation of ITIN numbers according to Ukrainian tax authority requirements.

  Validates an ITIN number to check if it meets length requirements and has a valid checksum.

  Returns:
   * `{:ok, itin}` if validation successful
   * `{:error, :length_too_short}` if shorter than required length
   * `{:error, :length_too_long}` if longer than required length
   * `{:error, :invalid_checksum}` if checksum is invalid

  Examples:

  ```elixir
      iex> UkraineTaxidEx.Itin.Validator.validate("3184710691")
      {:ok, "3184710691"}

      iex> UkraineTaxidEx.Itin.Validator.validate("123456")
      {:error, :length_too_short}

      iex> UkraineTaxidEx.Itin.Validator.validate("12345678901")
      {:error, :length_too_long}

      iex> UkraineTaxidEx.Itin.Validator.validate("3184710692")
      {:error, :invalid_checksum}
  ```
  """

  import UkraineTaxidEx.Itin, only: [length: 0]
  import UkraineTaxidEx.Itin.CheckSum, only: [check_sum: 1]

  use UkraineTaxidEx.BaseValidator
end
