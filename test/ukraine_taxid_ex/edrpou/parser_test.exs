defmodule UkraineTaxidEx.Edrpou.ParserTest do
  use ExUnit.Case
  alias UkraineTaxidEx.Edrpou
  alias UkraineTaxidEx.Edrpou.Parser
  doctest UkraineTaxidEx.Edrpou.Parser

  describe "parse/2" do
    test "successfully parses valid EDRPOU codes (strict cases, correct without normalization)" do
      valid_codes = [
        "00032112",
        "00032129",
        "09306278",
        "09620081",
        "09801546",
        "09806443",
        "09807595",
        "09807750",
        "09807862",
        "09809192",
        "13857564",
        "14070197",
        "14282829",
        "14305909",
        "14352406",
        "14359845",
        "14360080",
        "14360506",
        "14360570",
        "14360920",
        "14361575",
        "19355562",
        "19356610",
        "19358784",
        "19390819",
        "20023569",
        "20034231",
        "20042839",
        "20496061",
        "20953647",
        "21133352",
        "21322127",
        "21580639",
        "21650966",
        "21665382",
        "21677333",
        "21684818",
        "21685166",
        "21685485",
        "22868414",
        "23494714",
        "23697280",
        "26237202",
        "26410155",
        "26519933",
        "26520688",
        "32388371",
        "33695095",
        "34575675",
        "34576883",
        "35345213",
        "35590956",
        "35591059",
        "35810511",
        "35960913",
        "36002395",
        "36061927",
        "36520434",
        "37515069",
        "38324133",
        "38690683",
        "38870739",
        "39544699",
        "39849797",
        "43650988"
      ]

      for code <- valid_codes do
        assert {:ok, %Edrpou{code: ^code}} = Parser.parse(code)
      end
    end

    test "successfully parses valid EDRPOU codes (correct with normalization)" do
      valid_codes = [
        "32112",
        "032129",
        "0032129",
        "9306278",
        "9620081",
        "9801546",
        "9806443",
        "9807595",
        "13857564",
        "14361575",
        "19390819",
        "22868414",
        "34575675",
        "35960913",
        "36002395",
        "36061927",
        "43650988"
      ]

      for code <- valid_codes do
        leaded_code = String.pad_leading(code, 8, "0")
        assert {:ok, %Edrpou{code: ^leaded_code}} = Parser.parse(code, normalize?: true)
      end
    end

    test "successfully parses valid EDRPOU codes (correct after clean from non digit symbols)" do
      valid_codes = [
        "00-03-21-12",
        "00_03_21_29",
        "00 03 21 29",
        "0930 6278",
        "096 200 81",
        "09 80 1546",
        "09.80.64.43",
        "09/80/75/95",
        "13   857   564",
        "14361575",
        "193.908 19",
        "22868414",
        "345f75u67ck5",
        "35960913",
        "36002395",
        "36061927",
        "43650988"
      ]

      for code <- valid_codes do
        cleaned_code = String.replace(code, ~r/[^0-9]/, "")

        assert {:ok, %Edrpou{code: ^cleaned_code}} =
                 Parser.parse(code, normalize?: false, clean?: true)
      end
    end

    test "successfully parses valid EDRPOU codes (correct after clean and normalize)" do
      valid_codes = [
        "-3-21-12",
        "0_3_21_29",
        "   0003 21 29",
        "9306278.",
        "96 200 81",
        "09 80 1546",
        "09.80.64.43",
        "09/80/75/95"
      ]

      for code <- valid_codes do
        cleaned_and_normalized_code =
          code
          |> String.replace(~r/[^0-9]/, "")
          |> String.pad_leading(8, "0")

        assert {:ok, %Edrpou{code: ^cleaned_and_normalized_code}} =
                 Parser.parse(code, normalize?: true, clean?: true)
      end
    end
  end
end
