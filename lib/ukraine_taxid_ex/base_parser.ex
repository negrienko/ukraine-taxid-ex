defmodule UkraineTaxidEx.BaseParser do
  @typedoc """
  Options for parsing:
  - `:normalize?` - if true, pad the string to the right length (8 for EDRPOU, 10 for ITIN)
  - `:clean?` - if true, remove non-digit characters
  """
  @type options :: [normalize?: boolean, clean?: boolean]

  @callback parse(code :: String.t(), options :: options()) :: {:ok, term} | {:error, atom}

  defmacro __using__(_) do
    quote do
      @behaviour UkraineTaxidEx.BaseParser

      alias UkraineTaxidEx.BaseParser

      @type string_or_ok() :: String.t() | {:ok, String.t()}
      @type struct_or_error() :: {:ok, term} | {:error, atom()}

      @struct_module Module.split(__MODULE__) |> Enum.slice(0..-2//1) |> Module.safe_concat()
      # def struct_module(), do: @struct_module

      defp to_struct(map), do: struct(@struct_module, map)

      @impl BaseParser
      @spec parse(data :: string_or_ok, options :: BaseParser.options()) :: struct_or_error()
      def parse(data, options \\ [normalize?: false, clean?: false])
      def parse({:ok, string}, options), do: parse(string, options)
      def parse({:error, error}, _options), do: {:error, error}

      def parse(string, options) do
        length = (Keyword.get(options, :normalize?, false) && length()) || 0
        clean? = Keyword.get(options, :clean?, false)

        string
        |> digits(length, clean?)
        |> undigits()
        |> validate()
        |> generate()
      end

      defp generate({:error, error}), do: {:error, error}
      defp generate({:ok, string}), do: generate(string)
    end
  end
end
