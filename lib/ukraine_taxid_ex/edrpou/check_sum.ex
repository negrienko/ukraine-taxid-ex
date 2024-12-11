defmodule UkraineTaxidEx.Edrpou.CheckSum do
  alias UkraineTaxidEx.Commons, as: C

  import UkraineTaxidEx.Commons, only: [value_digits: 1]

  @typedoc """
    Coefficients (weights) for digits to calculate EDRPOU check sum may be two types:
    base ([1, 2, 3, 4, 5, 6, 7] for EDRPOU < 30M or EDRPOU > 60M)
    or alternative ([7, 1, 2, 3, 4, 5, 6] if EDRPOU between 30M and 60M)
  """
  @type weights_type :: :base | :alternative

  @doc """
    Calculate checksum for EDRPOU number.
    The checksum for EDRPOU is calculated in several steps:
    1. Define the type of weights (base or alternative) as described in `weights_type/1`
    2. Multiply each digit by its corresponding weight
    3. Sum the products
    4. Take mod 11 of the sum
    5. If mod 11 is greater or equal than 10, repeat steps 2-4 with doubled weights
  """
  @spec check_sum(digits :: C.digits()) :: integer()
  def check_sum(digits) do
    type =
      digits
      |> Integer.undigits()
      |> weights_type()

    value_digits = value_digits(digits)

    case calculate_check_sum(value_digits, weights(type, false)) do
      s when s >= 10 -> calculate_check_sum(value_digits, weights(type, true))
      s -> s
    end
  end

  defguardp is_base_weights(value) when value < 30_000_000 or value > 60_000_000

  @spec weights(type :: weights_type, double_added? :: boolean()) :: C.digits()
  defp weights(type \\ :base, double_added \\ false)
  defp weights(:base, false), do: Enum.to_list(1..7)

  defp weights(:alternative, false) do
    base = weights()
    [List.last(base) | Enum.take(base, length(base) - 1)]
  end

  defp weights(type, true) do
    type
    |> weights(false)
    |> Enum.map(&(&1 + 2))
  end

  @spec divider() :: non_neg_integer()
  defp divider(), do: 11

  @spec weights_type(value :: pos_integer()) :: C.digits()
  defp weights_type(value) when is_base_weights(value), do: :base
  defp weights_type(_value), do: :alternative

  @spec calculate_check_sum(digits :: C.digits(), weights :: C.digits()) :: non_neg_integer()
  defp calculate_check_sum(digits, weights) do
    digits
    |> Enum.zip(weights)
    |> Enum.reduce(0, fn {digit, weight}, acc -> digit * weight + acc end)
    |> rem(divider())
  end
end
