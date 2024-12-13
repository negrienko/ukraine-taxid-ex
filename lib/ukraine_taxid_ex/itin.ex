defmodule UkraineTaxidEx.Itin do
  @moduledoc """
  Documentation for `UkraineTaxidEx.Itin`.

  The ITIN is a unique 10-digit number that identifies individuals in Ukraine. It is issued to all individuals when they are registered in the official tax register. The Individual Taxpayer Identification Number (ITIN) is an automated system that collects, stores, and processes data on individuals in Ukraine.
  """

  @length 10

  @type gender :: 0 | 1
  @type t :: %__MODULE__{
          code: String.t(),
          birth_date: Date.t(),
          number: integer(),
          gender: gender,
          check_digit: C.digit(),
          check_sum: C.digit()
        }

  defstruct code: nil, birth_date: nil, number: nil, gender: nil, check_digit: nil, check_sum: nil

  use UkraineTaxidEx.Base
end
