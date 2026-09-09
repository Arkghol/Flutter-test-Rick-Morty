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

    def test_supports_trigonometry_in_degrees(self) -> None:
        self.assertAlmostEqual(calculate("sin(90)", "deg"), 1)
        self.assertAlmostEqual(calculate("acos(0)", "deg"), 90)

    def test_supports_functions_and_constants(self) -> None:
        self.assertAlmostEqual(calculate("sqrt(16) + ln(e) + log(100)"), 7)
        self.assertEqual(calculate("factorial(5) + cbrt(27)"), 123)

    def test_rejects_unknown_functions_and_invalid_domains(self) -> None:
        with self.assertRaises(CalculatorError):
            calculate("eval('2 + 2')")
        with self.assertRaises(CalculatorError):
            calculate("sqrt(-1)")

    def test_rejects_invalid_angle_mode(self) -> None:
        with self.assertRaises(CalculatorError):
            calculate("sin(1)", "grad")


if __name__ == "__main__":
    unittest.main()
