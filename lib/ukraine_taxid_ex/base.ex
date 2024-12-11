defmodule UkraineTaxidEx.Base do
  @callback to_map(data :: term) :: map()
  @callback to_string(data :: term) :: String.t()
  @callback length() :: non_neg_integer()

  defmacro __using__(_) do
    quote do
      @behaviour UkraineTaxidEx.Base

      alias UkraineTaxidEx.{Base, Serialize, Commons}

      @impl Base
      @spec length() :: non_neg_integer()
      def length(), do: @length

      @impl Base
      @spec to_map(data :: t()) :: map()
      defdelegate to_map(data), to: Serialize

      @impl Base
      @spec to_string(data :: t()) :: binary()
      defdelegate to_string(data), to: Serialize

      defoverridable to_string: 1, to_map: 1, length: 0
    end
  end
end
