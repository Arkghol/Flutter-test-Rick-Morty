"""A small command-line calculator with safe arithmetic expression evaluation."""

from __future__ import annotations

import ast
import math
import operator
from typing import Callable


Number = int | float

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


class CalculatorError(ValueError):
    """Raised when an expression cannot be evaluated by the calculator."""


def _evaluate_node(node: ast.AST) -> Number:
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        if isinstance(node.value, bool) or not math.isfinite(node.value):
            raise CalculatorError("используйте конечные числовые значения")
        return node.value

    if isinstance(node, ast.BinOp) and type(node.op) in _BINARY_OPERATORS:
        left = _evaluate_node(node.left)
        right = _evaluate_node(node.right)
        try:
            result = _BINARY_OPERATORS[type(node.op)](left, right)
        except (ArithmeticError, OverflowError) as error:
            raise CalculatorError("невозможно выполнить операцию") from error
        if isinstance(result, float) and not math.isfinite(result):
            raise CalculatorError("результат слишком велик")
        return result

    if isinstance(node, ast.UnaryOp) and type(node.op) in _UNARY_OPERATORS:
        return _UNARY_OPERATORS[type(node.op)](_evaluate_node(node.operand))

    raise CalculatorError("поддерживаются только числа и операции +, -, *, /, %, **")


def calculate(expression: str) -> Number:
    """Evaluate one arithmetic expression and return its numeric result."""
    if not expression.strip():
        raise CalculatorError("введите выражение")

    try:
        tree = ast.parse(expression, mode="eval")
    except SyntaxError as error:
        raise CalculatorError("некорректное выражение") from error

    return _evaluate_node(tree.body)


def _format_result(result: Number) -> str:
    if isinstance(result, float) and result.is_integer():
        return str(int(result))
    return str(result)


def main() -> None:
    print("Калькулятор. Введите выражение или 'q' для выхода.")
    while True:
        try:
            expression = input("> ")
        except (EOFError, KeyboardInterrupt):
            print()
            break

        if expression.strip().lower() in {"q", "quit", "exit"}:
            break

        try:
            print(_format_result(calculate(expression)))
        except CalculatorError as error:
            print(f"Ошибка: {error}")


if __name__ == "__main__":
    main()
