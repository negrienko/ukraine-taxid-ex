defmodule UkraineTaxidEx.BaseValidator do
  @callback validate(String.t()) ::
              {:ok, String.t()}
              | {:error,
                 :length_too_short | :length_too_long | :invalid_length | :invalid_checksum}
  @callback violates_length?(String.t()) :: boolean
  @callback violates_length_too_short?(String.t()) :: boolean
  @callback violates_length_too_long?(String.t()) :: boolean
  @callback violates_checksum?(String.t()) :: boolean

  defmacro __using__(_) do
    quote do
      alias UkraineTaxidEx.BaseValidator

      @behaviour UkraineTaxidEx.BaseValidator
      import UkraineTaxidEx.Commons, only: [digits: 1, digits_and_check_digit: 1, error: 1, ok: 1]

      @impl BaseValidator
      @spec validate(String.t()) ::
              {:ok, String.t()}
              | {:error,
                 :length_too_short | :length_too_long | :invalid_length | :invalid_checksum}
      def validate(string) do
        cond do
          violates_length_too_short?(string) -> error(:length_too_short)
          violates_length_too_long?(string) -> error(:length_too_long)
          violates_checksum?(string) -> error(:invalid_checksum)
          true -> ok(string)
        end
      end

      @doc "Check whether a given EDRPOU violates the required length"
      @impl BaseValidator
      @spec violates_length?(String.t()) :: boolean
      def violates_length?(string),
        do: String.length(string) != length()

      @doc "Check whether a given EDRPOU too short"
      @impl BaseValidator
      @spec violates_length_too_short?(String.t()) :: boolean
      def violates_length_too_short?(string),
        do: String.length(string) < length()

      @doc "Check whether a given EDRPOU too long"
      @impl BaseValidator
      @spec violates_length_too_long?(String.t()) :: boolean
      def violates_length_too_long?(string),
        do: String.length(string) > length()

      @doc "Check whether a given EDRPOU has correct checksum"
      @impl BaseValidator
      @spec violates_checksum?(String.t()) :: boolean
      def violates_checksum?(string) do
        {digits, check_digit} =
          string
          |> digits()
          |> digits_and_check_digit()

        check_sum = check_sum(digits)

        check_sum != check_digit
      end
    end
  end
end
