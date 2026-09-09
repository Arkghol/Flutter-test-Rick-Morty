import unittest

from calculator import CalculatorError, calculate


class CalculatorTests(unittest.TestCase):
    def test_calculates_arithmetic_with_parentheses(self) -> None:
        self.assertEqual(calculate("(2 + 3) * 4 - 6 / 2"), 17)

    def test_supports_power_and_remainder(self) -> None:
        self.assertEqual(calculate("2 ** 3 % 3"), 2)

    def test_supports_unary_operators(self) -> None:
        self.assertEqual(calculate("-5 + +2"), -3)

    def test_rejects_unsupported_python_code(self) -> None:
        with self.assertRaises(CalculatorError):
            calculate("__import__('os').system('echo unsafe')")

    def test_reports_division_by_zero(self) -> None:
        with self.assertRaises(CalculatorError):
            calculate("10 / 0")


if __name__ == "__main__":
    unittest.main()
