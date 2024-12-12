defmodule UkraineTaxidEx.Edrpou.Parser do
  @moduledoc """
  Parser module for EDRPOU (Unified State Register of Ukrainian Enterprises and Organizations) codes.
  Handles validation and structure creation for EDRPOU codes with additional options for normalization and cleaning.
  """

  alias UkraineTaxidEx.Edrpou

  import UkraineTaxidEx.Edrpou, only: [length: 0]
  import UkraineTaxidEx.Edrpou.CheckSum, only: [check_sum: 1]
  import UkraineTaxidEx.Edrpou.Validator, only: [validate: 1]
  import UkraineTaxidEx.Commons, only: [check_digit: 1, digits: 1, digits: 3, undigits: 1, ok: 1]

  use UkraineTaxidEx.BaseParser

  @type edrpou_string() :: String.t()
  @type edrpou_string_or_ok() :: edrpou_string() | {:ok, edrpou_string()}
  @type edrpou() :: Edrpou.t()
  @type edrpou_or_error() ::
          {:ok, Edrpou.t()}
          | {:error,
             :length_too_short
             | :length_too_long
             | :invalid_length
             | :invalid_checksum}

  @impl BaseParser

  @doc """
  Parses an EDRPOU code string into a structured format.
  Options:
  - normalize?: When true, pads string to full EDRPOU length. Defaults to false.
  - clean?: When true, removes non-digit characters before processing. Defaults to false.
  Returns {:ok, %Edrpou{}} for valid codes or {:error, reason} for invalid.

  ## Examples

      iex> UkraineTaxidEx.Edrpou.Parser.parse("00032112")
      {:ok, %UkraineTaxidEx.Edrpou{code: "00032112", check_digit: 2, check_sum: 2}}

      iex> UkraineTaxidEx.Edrpou.Parser.parse({:ok, "00032112"})
      {:ok, %UkraineTaxidEx.Edrpou{code: "00032112", check_digit: 2, check_sum: 2}}

      iex> UkraineTaxidEx.Edrpou.Parser.parse("32129", normalize?: true)
      {:ok, %UkraineTaxidEx.Edrpou{code: "00032129", check_digit: 9, check_sum: 9}}

      iex> UkraineTaxidEx.Edrpou.Parser.parse("9 30test62 78", normalize?: true, clean?: true)
      {:ok, %UkraineTaxidEx.Edrpou{code: "09306278", check_digit: 8, check_sum: 8}}

      iex> UkraineTaxidEx.Edrpou.Parser.parse("123")
      {:error, :length_too_short}

      iex> UkraineTaxidEx.Edrpou.Parser.parse("123456789")
      {:error, :length_too_long}

      iex> UkraineTaxidEx.Edrpou.Parser.parse("123", normalize?: true)
      {:error, :invalid_checksum}
  """
  @spec parse(data :: edrpou_string_or_ok, options :: BaseParser.options()) ::
          edrpou_or_error()
  def parse(data, options \\ [normalize?: false, clean?: false])
  def parse({:ok, edrpou_string}, options), do: parse(edrpou_string, options)
  def parse({:error, error}, _options), do: {:error, error}

  def parse(edrpou_string, options) do
    length = (Keyword.get(options, :normalize?, false) && length()) || 0
    clean? = Keyword.get(options, :clean?, false)

    edrpou_string
    |> digits(length, clean?)
    |> undigits()
    |> validate()
    |> generate_edrpou()
  end

  defp generate_edrpou({:error, error}), do: {:error, error}

  defp generate_edrpou({:ok, edrpou_string}) do
    digits = digits(edrpou_string)

    %{code: edrpou_string, check_sum: check_sum(digits), check_digit: check_digit(digits)}
    |> create_struct()
    |> ok()
  end

  defp create_struct(map), do: struct(Edrpou, map)
end
