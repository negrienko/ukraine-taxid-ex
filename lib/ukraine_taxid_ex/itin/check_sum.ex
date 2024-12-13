defmodule UkraineTaxidEx.Itin.CheckSum do
  @moduledoc """
  Module for calculating the checksum of Ukrainian Individual Tax Identification Numbers (ITIN).
  Provides functions for checksum calculation based on weighted digits and helper functions
  for working with ITIN weights and dividers. Uses specified numerical weights to multiply
  each digit of the ITIN and validate its authenticity.
  """

  alias UkraineTaxidEx.Commons, as: C

  import UkraineTaxidEx.Commons, only: [value_digits: 1]

  @weights [-1, 5, 7, 9, 4, 6, 10, 5, 7]

  @doc """
  Returns the list of numerical weights used to calculate the ITIN checksum.
  Each digit in the ITIN is multiplied by its corresponding weight.
  """
  @spec weights() :: C.digits()
  def weights(), do: @weights

  @spec divider() :: non_neg_integer()
  defp divider(), do: 11

  @doc """
    Calculate checksum for ITIN number.
    The checksum for ITIN is calculated in several steps:
    1. Multiply each digit by its corresponding weight
    2. Sum the products
    3. Take mod 11 of the sum
    4. If mod 11 is greater or equal than 10, repeat steps 2-4 with weights +2
  """
  @spec check_sum(digits :: C.digits(), weights :: C.digits()) :: integer()
  def check_sum(digits, weights \\ @weights) do
    digits
    |> value_digits()
    |> Enum.zip(weights)
    |> Enum.reduce(0, fn {digit, weight}, acc -> digit * weight + acc end)
    |> rem(divider())
    |> rem(10)
  end
end
