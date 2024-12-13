defmodule UkraineTaxidEx.Itin.CheckSumTest do
  use ExUnit.Case, async: true
  alias UkraineTaxidEx.Itin.CheckSum

  describe "weights/0" do
    test "returns the correct list of weights" do
      expected_weights = [-1, 5, 7, 9, 4, 6, 10, 5, 7]
      assert CheckSum.weights() == expected_weights
    end

    test "returns a list of 9 weights" do
      assert length(CheckSum.weights()) == 9
    end
  end

  describe "check_sum/2" do
    test "calculates correct checksum for valid ITIN (3334513284)" do
      # Test case with known ITIN and its checksum
      digits = [3, 3, 3, 4, 5, 1, 3, 2, 8, 4]
      assert CheckSum.check_sum(digits) == 4
    end

    test "calculates correct checksum for valid ITIN (2038817850)" do
      # Test case with known ITIN and its checksum
      digits = [2, 0, 3, 8, 8, 1, 7, 8, 5, 0]
      assert CheckSum.check_sum(digits) == 0
    end

    test "calculates correct checksum for valid ITIN (3486110380)" do
      # Test case with known ITIN and its checksum
      digits = [3, 4, 8, 6, 1, 1, 0, 3, 8, 0]
      assert CheckSum.check_sum(digits) == 0
    end

    test "calculates correct checksum for valid ITIN (3402109517)" do
      # Test case with known ITIN and its checksum
      digits = [3, 4, 0, 2, 1, 0, 9, 5, 1, 7]
      assert CheckSum.check_sum(digits) == 7
    end

    test "calculates correct checksum for valid ITIN (2598917292)" do
      # Test case with known ITIN and its checksum
      digits = [2, 5, 9, 8, 9, 1, 7, 2, 9, 2]
      assert CheckSum.check_sum(digits) == 2
    end

    test "calculates correct checksum for valid ITIN (3505804094)" do
      # Test case with known ITIN and its checksum
      digits = [3, 5, 0, 5, 8, 0, 4, 0, 9, 4]
      assert CheckSum.check_sum(digits) == 4
    end

    test "calculates correct checksum for valid ITIN (2971306745)" do
      # Test case with known ITIN and its checksum
      digits = [2, 9, 7, 1, 3, 0, 6, 7, 4, 5]
      assert CheckSum.check_sum(digits) == 5
    end

    test "calculates correct checksum for ITIN with invalid check digit (2598917291)" do
      # Test case with known ITIN and its checksum
      digits = [2, 5, 9, 8, 9, 1, 7, 2, 9, 1]
      assert CheckSum.check_sum(digits) == 2
    end

    test "calculates correct checksum for ITIN with invalid check digit (3505804099)" do
      # Test case with known ITIN and its checksum
      digits = [3, 5, 0, 5, 8, 0, 4, 0, 9, 9]
      assert CheckSum.check_sum(digits) == 4
    end

    test "calculates correct checksum for ITIN with invalid check digit (2971306747)" do
      # Test case with known ITIN and its checksum
      digits = [2, 9, 7, 1, 3, 0, 6, 7, 4, 7]
      assert CheckSum.check_sum(digits) == 5
    end

    test "calculates checksum with custom weights" do
      digits = [1, 2, 3]
      weights = [1, 2, 3]
      assert CheckSum.check_sum(digits, weights) == 5
    end

    test "handles zero digits" do
      digits = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      assert CheckSum.check_sum(digits) == 0
    end

    test "handles single digit input" do
      digits = [5]
      weights = [2]
      # (5*2) = 10 % 11 % 10 = 0
      assert CheckSum.check_sum(digits, weights) == 0
    end
  end
end
