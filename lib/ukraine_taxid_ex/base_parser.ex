defmodule UkraineTaxidEx.BaseParser do
  @type options :: [incomplete: boolean]
  @callback parse(string :: String.t(), options :: options()) :: {:ok, term} | {:error, atom}

  defmacro __using__(_) do
    quote do
      @behaviour UkraineTaxidEx.BaseParser

      alias UkraineTaxidEx.BaseParser

      @impl BaseParser
      @spec parse(string :: String.t(), options :: BaseParser.options()) ::
              {:ok, term} | {:error, atom}
      def parse(data, options \\ [incomplete: false])

      defoverridable parse: 2, parse: 1
    end
  end
end
