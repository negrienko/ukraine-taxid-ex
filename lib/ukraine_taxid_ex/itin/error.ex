defmodule UkraineTaxidEx.Itin.Error do
  @type error() ::
          :invalid_length
          | :invalid_checksum
          | :length_too_long
          | :length_too_short
  @type errors() :: [error()]
  @errors [
    :invalid_length,
    :invalid_checksum,
    :length_too_long,
    :length_too_short
  ]
  @messages [
    invalid_length: "ITIN violates the required length",
    invalid_checksum: "ITIN checksum is invalid",
    length_too_long: "ITIN longer then required length",
    length_too_short: "ITIN shorter then required length"
  ]

  @spec message(error()) :: String.t()
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
