defmodule UkraineTaxidEx.Itin.ParserTest do
  use ExUnit.Case, async: true
  alias UkraineTaxidEx.Itin
  alias UkraineTaxidEx.Itin.Parser

  describe "parse/1" do
    test "successfully parses valid ITIN" do
      assert {:ok, %Itin{} = itin} = Parser.parse("2847211760")
      assert itin.code == "2847211760"
      assert itin.birth_date == ~D[1977-12-14]
      assert itin.number == 1176
      assert itin.gender == 0
      assert itin.check_sum == 0
      assert itin.check_digit == 0

      assert {:ok, %Itin{} = itin} = Parser.parse("3176422893")
      assert itin.code == "3176422893"
      assert itin.birth_date == ~D[1986-12-19]
      assert itin.number == 2289
      assert itin.gender == 1
      assert itin.check_sum == 3
      assert itin.check_digit == 3
    end

    test "returns error for string shorter than required length" do
      assert {:error, :length_too_short} = Parser.parse("123456")
    end

    test "returns error for string longer than required length" do
      assert {:error, :length_too_long} = Parser.parse("12345678901")
    end

    test "returns error for invalid checksum" do
      assert {:error, :invalid_checksum} = Parser.parse("1234567890")
    end
  end

  describe "birth_date/1" do
    test "calculates correct birth date from digits" do
      digits = [3, 7, 5, 8, 0, 0, 5, 3, 6, 4]
      assert Parser.birth_date(digits) == ~D[2002-11-21]

      digits = [3, 0, 4, 3, 2, 1, 6, 8, 2, 4]
      assert Parser.birth_date(digits) == ~D[1983-04-27]

      digits = [2, 8, 8, 1, 2, 2, 0, 4, 5, 2]
      assert Parser.birth_date(digits) == ~D[1978-11-19]
    end
  end

  describe "number/1" do
    test "extracts correct number from digits" do
      digits = [2, 8, 8, 1, 2, 2, 0, 4, 5, 2]
      assert Parser.number(digits) == 2045

      digits = [3, 5, 8, 9, 4, 1, 2, 3, 7, 1]
      assert Parser.number(digits) == 1237

      digits = [3, 2, 1, 5, 6, 0, 5, 0, 5, 3]
      assert Parser.number(digits) == 505
    end
  end

  describe "gender/1" do
    test "determines correct gender from digits" do
      # Even number in the second-to-last position (gender 1)
      digits = [2, 5, 8, 5, 1, 1, 9, 1, 1, 5]
      assert Parser.gender(digits) == 1

      digits = [2, 6, 0, 3, 8, 2, 1, 5, 3, 1]
      assert Parser.gender(digits) == 1

      # Odd number in the second-to-last position (gender 0)
      digits = [2, 2, 0, 7, 3, 1, 5, 4, 2, 8]
      assert Parser.gender(digits) == 0

      digits = [3, 1, 2, 6, 7, 0, 7, 0, 2, 6]
      assert Parser.gender(digits) == 0
    end
  end

  describe "base_date/0" do
    test "returns the correct base date" do
      assert Parser.base_date() == ~D[1899-12-31]
    end
  end
end
