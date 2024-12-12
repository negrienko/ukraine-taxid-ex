defmodule UkraineTaxidEx.BaseParser do
  @type options :: [normalize?: boolean, clean?: boolean]
  @callback parse(string :: String.t(), options :: options()) :: {:ok, term} | {:error, atom}

  defmacro __using__(_) do
    quote do
      @behaviour UkraineTaxidEx.BaseParser

      alias UkraineTaxidEx.BaseParser
    end
  end
end
