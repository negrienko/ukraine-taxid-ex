defmodule UkraineTaxidEx.Edrpou.CheckSumTest do
  use ExUnit.Case
  alias UkraineTaxidEx.Edrpou.CheckSum
  doctest UkraineTaxidEx.Edrpou.Parser

  describe "weights/2" do
    test "returns base weights by default" do
      assert CheckSum.weights() == [1, 2, 3, 4, 5, 6, 7]
    end

    test "returns base weights when not added 2" do
      assert CheckSum.weights(:base, false) == [1, 2, 3, 4, 5, 6, 7]
    end

    test "returns alternative weights when added 2" do
      assert CheckSum.weights(:alternative, false) == [7, 1, 2, 3, 4, 5, 6]
    end

    test "returns base weights + 2" do
      assert CheckSum.weights(:base, true) == [3, 4, 5, 6, 7, 8, 9]
    end

    test "returns alternative weights + 2 " do
      assert CheckSum.weights(:alternative, true) == [9, 3, 4, 5, 6, 7, 8]
    end
  end

  describe "check_sum/1" do
    test "calculates correct checksum for EDRPOU with base weights (< 30M) short EDRPOU with leading zeros" do
      # Example EDRPOU: 0003212[9] (where 2 is the check digit)
      digits = [0, 0, 0, 3, 2, 1, 2, 9]
      assert CheckSum.check_sum(digits) == 9
    end

    test "calculates correct checksum for EDRPOU with base weights (< 30M)" do
      # Example EDRPOU: 1436050[6] (where 2 is the check digit)
      digits = [1, 4, 3, 6, 0, 5, 0, 6]
      assert CheckSum.check_sum(digits) == 6
    end

    test "calculates correct checksum for EDRPOU with base weights (> 60M)" do
      # Example EDRPOU: 6543217[6]
      digits = [6, 5, 4, 3, 2, 1, 7, 6]
      assert CheckSum.check_sum(digits) == 6
    end

    test "calculates correct checksum for EDRPOU with alternative weights (30M-60M)" do
      # Example EDRPOU: 3145193[2]
      digits = [3, 1, 4, 5, 1, 9, 3, 2]
      assert CheckSum.check_sum(digits) == 2
    end

    test "calculates correct checksum for EDRPOU with alternative weights (30M-60M) when first calculation >= 10" do
      # Example EDRPOU: 3702668[4]
      digits = [3, 7, 0, 2, 6, 6, 8, 4]
      assert CheckSum.check_sum(digits) == 4
    end

    test "calculates correct checksum for EDRPOU with base weights when first calculation >= 10" do
      # Example EDRPOU: 2113335[2]
      digits = [2, 1, 1, 3, 3, 3, 5, 2]
      assert CheckSum.check_sum(digits) == 2
    end

    test "handles edge case at 30M boundary" do
      # Just below 30M
      digits = [2, 9, 9, 9, 9, 9, 9]
      result_below = CheckSum.check_sum(digits)

      # Just at 30M
      digits = [3, 0, 0, 0, 0, 0, 0]
      result_at = CheckSum.check_sum(digits)

      assert result_below != result_at
    end

    test "handles edge case at 60M boundary" do
      # Just below 60M
      digits = [5, 9, 9, 9, 9, 9, 9]
      result_below = CheckSum.check_sum(digits)

      # Just at 60M
      digits = [6, 0, 0, 0, 0, 0, 0]
      result_at = CheckSum.check_sum(digits)

      assert result_below != result_at
    end
  end
end
