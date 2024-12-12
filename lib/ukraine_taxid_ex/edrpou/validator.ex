defmodule UkraineTaxidEx.Edrpou.Validator do
  @moduledoc """
  Functions for validating EDRPOU number format and checksum.

  This module provides validation functions to verify if an EDRPOU number meets the standard requirements including length and checksum validation.
  """

  import UkraineTaxidEx.Commons, only: [digits: 1, digits_and_check_digit: 1, error: 1, ok: 1]
  import UkraineTaxidEx.Edrpou, only: [length: 0]
  import UkraineTaxidEx.Edrpou.CheckSum, only: [check_sum: 1]

  @doc """
  Validates an EDRPOU number to check if it meets length requirements and has a valid checksum.

  Returns:
   * `{:ok, edrpou}` if validation successful
   * `{:error, :length_too_short}` if shorter than required length
   * `{:error, :length_too_long}` if longer than required length
   * `{:error, :invalid_checksum}` if checksum is invalid
  """
  @spec validate(String.t()) ::
          {:ok, String.t()}
          | {:error, :length_too_short | :length_too_long | :invalid_length | :invalid_checksum}
  def validate(edrpou) do
    cond do
      violates_length_too_short?(edrpou) -> error(:length_too_short)
      violates_length_too_long?(edrpou) -> error(:length_too_long)
      violates_checksum?(edrpou) -> error(:invalid_checksum)
      true -> ok(edrpou)
    end
  end

  @doc "Check whether a given EDRPOU violates the required length"
  @spec violates_length?(String.t()) :: boolean
  def violates_length?(edrpou),
    do: String.length(edrpou) != length()

  @doc "Check whether a given EDRPOU too short"
  @spec violates_length_too_short?(String.t()) :: boolean
  def violates_length_too_short?(edrpou),
    do: String.length(edrpou) < length()

  @doc "Check whether a given EDRPOU too long"
  @spec violates_length_too_long?(String.t()) :: boolean
  def violates_length_too_long?(edrpou),
    do: String.length(edrpou) > length()

  @doc "Check whether a given EDRPOU has correct checksum"
  @spec violates_checksum?(String.t()) :: boolean
  def violates_checksum?(edrpou) do
    {digits, check_digit} =
      edrpou
      |> digits()
      |> digits_and_check_digit()

    check_sum = check_sum(digits)

    check_sum != check_digit
  end
end
