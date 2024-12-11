defmodule UkraineTaxidEx.Serialize do
  @spec to_string(Edrpou.t() | Itin.t()) :: String.t()
  def to_string(data), do: data.code

  @spec to_map(Edrpou.t() | Itin.t()) :: map()
  def to_map(data), do: Map.from_struct(data)
end
