defmodule UkraineTaxidEx.CommonsTest do
  use ExUnit.Case
  alias UkraineTaxidEx.Commons
  doctest UkraineTaxidEx.Commons

  describe "digits/2" do
    test "converts string to list of digits" do
      assert Commons.digits("123") == [1, 2, 3]
      assert Commons.digits("456") == [4, 5, 6]
      assert Commons.digits("789") == [7, 8, 9]
    end

    test "converts integer to list of digits" do
      assert Commons.digits(123) == [1, 2, 3]
      assert Commons.digits(456) == [4, 5, 6]
      assert Commons.digits(789) == [7, 8, 9]
    end

    test "pads with zeros when length is specified" do
      assert Commons.digits("123", 5) == [0, 0, 1, 2, 3]
      assert Commons.digits(123, 5) == [0, 0, 1, 2, 3]
      assert Commons.digits("45", 4) == [0, 0, 4, 5]
    end

    test "handles strings with non-digit characters" do
      assert Commons.digits("1-2-3", 0, true) == [1, 2, 3]
      assert Commons.digits("A1B2C3", 0, true) == [1, 2, 3]
      assert Commons.digits("12.34", 0, true) == [1, 2, 3, 4]
    end

    test "handles empty string" do
      assert Commons.digits("") == []
      assert Commons.digits("", 3) == [0, 0, 0]
    end
  end

  describe "check_digit/1" do
    test "returns the last digit from the list" do
      assert Commons.check_digit([1, 2, 3, 4, 5]) == 5
      assert Commons.check_digit([9, 8, 7]) == 7
    end

    test "returns nil for empty list" do
      assert Commons.check_digit([]) == nil
    end
  end

  describe "value_digits/1" do
    test "returns all digits except the last one" do
      assert Commons.value_digits([1, 2, 3, 4, 5]) == [1, 2, 3, 4]
      assert Commons.value_digits([9, 8, 7]) == [9, 8]
    end

    test "returns empty list for empty input" do
      assert Commons.value_digits([]) == []
    end

    test "returns empty list for single digit input" do
      assert Commons.value_digits([1]) == []
    end
  end

  describe "value_and_check_digits/1" do
    test "returns tuple with value digits and check digit" do
      assert Commons.value_and_check_digits([1, 2, 3, 4, 5]) == {[1, 2, 3, 4], 5}
      assert Commons.value_and_check_digits([9, 8, 7]) == {[9, 8], 7}
    end

    test "handles empty list" do
      assert Commons.value_and_check_digits([]) == {[], nil}
    end

    test "handles single digit" do
      assert Commons.value_and_check_digits([1]) == {[], 1}
    end
  end

  describe "digits_and_check_digit/1" do
    test "returns tuple with original digits and check digit" do
      assert Commons.digits_and_check_digit([1, 2, 3, 4]) == {[1, 2, 3, 4], 4}
    end

    test "works with different digit sequences" do
      assert Commons.digits_and_check_digit([5, 6, 7, 8]) == {[5, 6, 7, 8], 8}
      assert Commons.digits_and_check_digit([9, 0, 1, 2]) == {[9, 0, 1, 2], 2}
    end

    test "handles single digit list" do
      assert Commons.digits_and_check_digit([1]) == {[1], 1}
    end

    test "handles empty list" do
      assert Commons.digits_and_check_digit([]) == {[], nil}
    end
  end

  describe "ok/1" do
    test "wraps data in ok tuple" do
      assert Commons.ok(123) == {:ok, 123}
      assert Commons.ok([1, 2, 3]) == {:ok, [1, 2, 3]}
      assert Commons.ok("test") == {:ok, "test"}
    end
  end

  describe "error/1" do
    test "wraps error in error tuple" do
      assert Commons.error("invalid") == {:error, "invalid"}
      assert Commons.error(:invalid_format) == {:error, :invalid_format}
    end
  end
end
