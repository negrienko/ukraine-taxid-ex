defmodule UkraineTaxidExTest do
  use ExUnit.Case, async: true
  doctest UkraineTaxidEx

  describe "determine/1" do
    test "correctly identifies ITIN tax ID" do
      assert {:ok, UkraineTaxidEx.Itin} = UkraineTaxidEx.determine("1234567890")
    end

    test "correctly identifies EDRPOU tax ID" do
      assert {:ok, UkraineTaxidEx.Edrpou} = UkraineTaxidEx.determine("12345678")
    end

    test "returns error for invalid length" do
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("123")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("1234")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("12345")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("123456")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("1234567")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("123456789")
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.determine("12345678901")
    end
  end

  describe "parse/1" do
    test "successfully parses valid ITIN" do
      assert {:ok, %{code: "1759013776"}, UkraineTaxidEx.Itin} =
               UkraineTaxidEx.parse("1759013776")
    end

    test "successfully parses valid EDRPOU" do
      assert {:ok, %{code: "30283027"}, UkraineTaxidEx.Edrpou} =
               UkraineTaxidEx.parse("30283027")
    end

    test "returns error for invalid tax ID" do
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.parse("123")
    end

    test "returns :length_too_short error for invalid format tax id (valid length but invalid after clean)" do
      assert {:error, :length_too_short, UkraineTaxidEx.Itin} =
               UkraineTaxidEx.parse("abcdefghij")

      assert {:error, :length_too_short, UkraineTaxidEx.Edrpou} =
               UkraineTaxidEx.parse("abcdefgh")
    end
  end

  describe "validate/1" do
    test "returns :invalid_checksum for ITIN with invalid checksum" do
      assert {:error, :invalid_checksum, UkraineTaxidEx.Itin} =
               UkraineTaxidEx.validate("1234567890")
    end

    test "returns :invalid_checksum for EDRPOU with invalid checksum" do
      assert {:error, :invalid_checksum, UkraineTaxidEx.Edrpou} =
               UkraineTaxidEx.validate("12345679")
    end

    test "returns error for invalid tax ID" do
      assert {:error, "Invalid tax ID length"} = UkraineTaxidEx.validate("123")
    end
  end
end
