defmodule UkraineTaxidEx.Edrpou.Error do
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
    invalid_length: "EDRPOU violates the required length",
    invalid_checksum: "EDRPOU checksum is invalid",
    length_too_long: "EDRPOU longer then required length",
    length_too_short: "EDRPOU shorter then required length"
  ]

  @spec message({:error, error()} | error()) :: String.t()
  def message({:error, error}) when error in @errors, do: @messages[error]
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
