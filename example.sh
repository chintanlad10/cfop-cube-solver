#!/bin/bash

# Example: How to use the CFOP Cube Solver

echo "CFOP Cube Solver - Usage Examples"
echo "================================="
echo ""

# Make sure the solver is built
if [ ! -f "./cube-solver" ]; then
    echo "Building cube solver..."
    make debug
    echo ""
fi

echo "Example 1: Simple scramble"
echo "Scramble: R U R' U'"
echo ""
echo "R U R' U'" | ./cube-solver
echo ""

echo "Example 2: Slightly more complex"
echo "Scramble: F R U' R' F'"
echo ""
echo "F R U' R' F'" | ./cube-solver
echo ""

echo "For interactive mode, just run: ./cube-solver"
echo "Enter your scramble using standard cube notation:"
echo "  U, U', U2 (Up face)"
echo "  D, D', D2 (Down face)" 
echo "  R, R', R2 (Right face)"
echo "  L, L', L2 (Left face)"
echo "  F, F', F2 (Front face)"
echo "  B, B', B2 (Back face)"
