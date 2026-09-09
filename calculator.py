"""A safe command-line engineering calculator."""

from __future__ import annotations

import ast
import math
import operator
from typing import Callable, Literal


Number = int | float
AngleMode = Literal["rad", "deg"]

_BINARY_OPERATORS: dict[type[ast.operator], Callable[[Number, Number], Number]] = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.Mod: operator.mod,
    ast.Pow: operator.pow,
}
_UNARY_OPERATORS: dict[type[ast.unaryop], Callable[[Number], Number]] = {
    ast.UAdd: operator.pos,
    ast.USub: operator.neg,
}
_CONSTANTS: dict[str, Number] = {
    "pi": math.pi,
    "e": math.e,
    "tau": math.tau,
}


_FUNCTIONS: dict[str, Callable[..., Number]] = {
    "abs": abs,
    "ceil": math.ceil,
    "floor": math.floor,
    "sqrt": math.sqrt,
    "cbrt": math.cbrt,
    "exp": math.exp,
    "ln": math.log,
    "log": math.log10,
    "log10": math.log10,
    "log2": math.log2,
    "sinh": math.sinh,
    "cosh": math.cosh,
    "tanh": math.tanh,
    "asinh": math.asinh,
    "acosh": math.acosh,
    "atanh": math.atanh,
    "factorial": math.factorial,
    "degrees": math.degrees,
    "radians": math.radians,
}


class CalculatorError(ValueError):
    """Raised when an expression cannot be evaluated by the calculator."""


def _angle(value: Number, angle_mode: AngleMode) -> float:
    return math.radians(value) if angle_mode == "deg" else float(value)


def _evaluate_call(node: ast.Call, angle_mode: AngleMode) -> Number:
    if not isinstance(node.func, ast.Name) or node.func.id not in {
        *set(_FUNCTIONS),
        "sin",
        "cos",
        "tan",
        "asin",
        "acos",
        "atan",
    }:
        raise CalculatorError("неизвестная функция")
    if node.keywords or len(node.args) != 1:
        raise CalculatorError("функции калькулятора принимают один аргумент")

    name = node.func.id
    value = _evaluate_node(node.args[0], angle_mode)
    if name in {"sin", "cos", "tan"}:
        function = getattr(math, name)
        result = function(_angle(value, angle_mode))
    elif name in {"asin", "acos", "atan"}:
        function = getattr(math, name)
        result = function(value)
        if angle_mode == "deg":
            result = math.degrees(result)
    else:
        result = _FUNCTIONS[name](value)
    return result


def _evaluate_node(node: ast.AST, angle_mode: AngleMode) -> Number:
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        if isinstance(node.value, bool) or not math.isfinite(node.value):
            raise CalculatorError("используйте конечные числовые значения")
        return node.value
    if isinstance(node, ast.Name) and node.id in _CONSTANTS:
        return _CONSTANTS[node.id]

    if isinstance(node, ast.BinOp) and type(node.op) in _BINARY_OPERATORS:
        left = _evaluate_node(node.left, angle_mode)
        right = _evaluate_node(node.right, angle_mode)
        try:
            result = _BINARY_OPERATORS[type(node.op)](left, right)
        except (ArithmeticError, OverflowError) as error:
            raise CalculatorError("невозможно выполнить операцию") from error
        if isinstance(result, float) and not math.isfinite(result):
            raise CalculatorError("результат слишком велик")
        return result

    if isinstance(node, ast.UnaryOp) and type(node.op) in _UNARY_OPERATORS:
        return _UNARY_OPERATORS[type(node.op)](
            _evaluate_node(node.operand, angle_mode)
        )
    if isinstance(node, ast.Call):
        try:
            result = _evaluate_call(node, angle_mode)
        except (ValueError, OverflowError, ZeroDivisionError, TypeError) as error:
            raise CalculatorError("аргумент находится вне допустимой области") from error
        if isinstance(result, float) and not math.isfinite(result):
            raise CalculatorError("результат слишком велик")
        return result

    raise CalculatorError("недопустимое выражение")


def calculate(expression: str, angle_mode: AngleMode = "rad") -> Number:
    """Evaluate one arithmetic expression and return its numeric result."""
    if not expression.strip():
        raise CalculatorError("введите выражение")
    if angle_mode not in {"rad", "deg"}:
        raise CalculatorError("режим углов должен быть 'rad' или 'deg'")

    try:
        tree = ast.parse(expression, mode="eval")
    except SyntaxError as error:
        raise CalculatorError("некорректное выражение") from error

    return _evaluate_node(tree.body, angle_mode)


def _format_result(result: Number) -> str:
    if isinstance(result, float) and result.is_integer():
        return str(int(result))
    return str(result)


def main() -> None:
    angle_mode: AngleMode = "rad"
    print("Инженерный калькулятор. 'help' — справка, 'q' — выход.")
    while True:
        try:
            expression = input("> ")
        except (EOFError, KeyboardInterrupt):
            print()
            break

        command = expression.strip().lower()
        if command in {"q", "quit", "exit"}:
            break
        if command in {"help", "?"}:
            print("Функции: sin, cos, tan, asin, acos, atan, sqrt, cbrt,")
            print("         ln, log, log2, exp, abs, factorial, sinh, cosh, tanh")
            print("Константы: pi, e, tau")
            print("Команды: mode deg, mode rad, q")
            continue
        if command in {"mode deg", "deg"}:
            angle_mode = "deg"
            print("Режим углов: градусы")
            continue
        if command in {"mode rad", "rad"}:
            angle_mode = "rad"
            print("Режим углов: радианы")
            continue

        try:
            print(_format_result(calculate(expression, angle_mode)))
        except CalculatorError as error:
            print(f"Ошибка: {error}")


if __name__ == "__main__":
    main()
