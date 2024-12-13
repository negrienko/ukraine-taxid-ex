defmodule UkraineTaxidEx.Edrpou do
  @moduledoc """
  Documentation for `UkraineTaxidEx.Edrpou`.

  The EDRPOU is a unique 8-digit number that identifies legal entities in Ukraine. It is issued to all companies when they are formed and registered in the official business register. The Unified State Register of Enterprises and Organizations of Ukraine (USREOU/EDRPOU) is an automated system that collects, stores, and processes data on legal entities in Ukraine.
  """

  @length 8

  @type t :: %__MODULE__{
          code: String.t(),
          check_digit: C.digit(),
          check_sum: C.digit()
        }

  defstruct code: nil, check_digit: nil, check_sum: nil

  use UkraineTaxidEx.Base
end
