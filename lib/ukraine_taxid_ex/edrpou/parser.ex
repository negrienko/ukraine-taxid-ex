defmodule UkraineTaxidEx.Edrpou.Parser do
  alias UkraineTaxidEx.Edrpou

  import UkraineTaxidEx.Edrpou, only: [length: 0]
  import UkraineTaxidEx.Edrpou.CheckSum, only: [check_sum: 1]
  import UkraineTaxidEx.Commons, only: [check_digit: 1, digits: 2, ok: 1]

  use UkraineTaxidEx.BaseParser

  def parse(edrpou_string, incomplete: false) do
    digits = digits(edrpou_string, length())

    %{
      code: edrpou_string,
      check_sum: check_sum(digits),
      check_digit: check_digit(digits)
    }
    |> create_struct()
    |> ok()
  end

  defp create_struct(map), do: struct(Edrpou, map)
end
