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
    invalid_length: "ITIN violates the required length",
    invalid_checksum: "ITIN checksum is invalid",
    length_to_long: "ITIN longer then required length",
    length_to_short: "ITIN shorter then required length"
  ]

  @spec message(error()) :: String.t()
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
