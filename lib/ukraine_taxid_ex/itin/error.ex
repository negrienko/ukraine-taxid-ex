defmodule UkraineTaxidEx.Itin.Error do
  @type error() ::
          :invalid_length
          | :invalid_checksum
          | :length_to_long
          | :length_to_short
  @type errors() :: [error()]
  @errors [
    :invalid_length,
    :invalid_checksum,
    :length_to_long,
    :length_to_short
  ]
  @messages [
    invalid_length: "EDRPOU violates the required length",
    invalid_checksum: "EDRPOU checksum is invalid",
    length_to_long: "EDRPOU longer then required length",
    length_to_short: "EDRPOU shorter then required length"
  ]

  @spec message(error()) :: String.t()
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
