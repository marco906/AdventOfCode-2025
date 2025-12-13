#!/usr/bin/env python3
from math import inf

import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds


def parse_machine(line):

    parts = line.split()
    buttons = []

    for part in parts[1:]:
        if part.startswith('{'):
            break
        indices = [int(x.strip()) for x in part.strip('()').split(',') if x.strip()]
        if indices:
            buttons.append(indices)

    joltages = [int(x.strip()) for x in parts[-1].strip('{}').split(',')]

    return buttons, joltages


def solve_machine_milp(buttons, joltages):

    n_positions = len(joltages)
    n_buttons = len(buttons)
    objective = np.ones(n_buttons, dtype=float)
    integrality = np.ones(n_buttons, dtype=int)

    # Bounds: each button can be pressed 0 or more times
    bounds = Bounds(
        lb=np.zeros(n_buttons, dtype=float),
        ub=np.full(n_buttons, inf, dtype=float),
    )

    # Constraint matrix: A[i][j] = 1 if button j affects position i, else 0
    constraint_matrix = np.array(
        [[1.0 if pos_idx in button else 0.0 for button in buttons]
         for pos_idx in range(n_positions)],
        dtype=float,
    )

    # Constraints: each position must be set to its target value
    target_values = np.array(joltages, dtype=float)
    constraints = LinearConstraint(constraint_matrix, lb=target_values, ub=target_values)

    # Solve MILP
    result = milp(
        c=objective,
        integrality=integrality,
        bounds=bounds,
        constraints=[constraints],
    )

    if result.success:
        return int(sum(round(x) for x in result.x))
    return None


def main():
    with open('Sources/Data/Day10.txt', 'r') as f:
        lines = [line.strip() for line in f if line.strip()]

    total_presses = 0

    for machine_num, line in enumerate(lines, 1):
        buttons, joltages = parse_machine(line)
        total_presses += solve_machine_milp(buttons, joltages)

    print(f"\nTotal presses: {total_presses}")

if __name__ == "__main__":
    main()
