defmodule UkraineTaxidEx.Base do
  @callback parse(data :: {:ok, String.t()} | String.t(), options :: Keyword.t()) ::
              {:ok, term} | {:error, atom()}
  @callback to_map(data :: term) :: map()
  @callback to_string(data :: term) :: String.t()
  @callback length() :: non_neg_integer()

  defmacro __using__(_) do
    quote do
      @behaviour UkraineTaxidEx.Base

      alias UkraineTaxidEx.{Base, Serialize, Commons}

      @parse_module (Module.split(__MODULE__) ++ ["Parser"]) |> Module.safe_concat()
      # def parse_module(), do: @parse_module

      @impl Base
      @spec to_map(data :: t()) :: map()
      defdelegate to_map(data), to: Serialize

      @impl Base
      @spec to_string(data :: t()) :: binary()
      defdelegate to_string(data), to: Serialize

      @doc """
      Returns the length of the code.
      """
      @impl Base
      @spec length() :: non_neg_integer()
      def length(), do: @length

      @impl Base
      @spec parse(data :: {:ok, String.t()} | String.t(), options :: Keyword.t()) ::
              {:ok, t()} | {:error, atom()}
      defdelegate parse(data, options \\ [normalize?: false, clean?: false]), to: @parse_module

      defoverridable to_string: 1, to_map: 1, length: 0, parse: 2
    end
  end
end
