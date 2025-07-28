#!/bin/bash

# CFOP Cube Solver Test Script
# This script demonstrates the cube solver with various test cases

echo "======================================"
echo "CFOP Rubik's Cube Solver Test Suite"
echo "======================================"
echo ""

# Build the project first
echo "Building the cube solver..."
make clean && make debug

if [ $? -ne 0 ]; then
    echo "Build failed! Please check for compilation errors."
    exit 1
fi

echo "Build successful!"
echo ""

# Test cases - various scrambles of different complexities
declare -a test_scrambles=(
    "R U R' U'"                                    # Simple 4-move scramble
    "F R U' R' F' R U R'"                         # Simple cross pattern
    "R U R' F' R U R' U' R' F R2 U' R'"          # More complex pattern  
    "D' R' D R2 U' R D' R' U R'"                  # Different face starts
    "L D L' U L D' L' U'"                         # Left-hand pattern
    "F U R U' R' F' R U R'"                       # Mixed face pattern
)

declare -a test_names=(
    "Simple 4-move scramble"
    "Cross pattern"
    "Complex pattern"
    "Different starting face"
    "Left-hand pattern" 
    "Mixed face pattern"
)

echo "Running test cases..."
echo ""

for i in "${!test_scrambles[@]}"; do
    echo "----------------------------------------"
    echo "Test $((i+1)): ${test_names[$i]}"
    echo "Scramble: ${test_scrambles[$i]}"
    echo "----------------------------------------"
    
    # Run the solver with the scramble
    echo "${test_scrambles[$i]}" | timeout 30s ./cube-solver
    
    if [ $? -eq 124 ]; then
        echo "ERROR: Solver timed out after 30 seconds!"
    fi
    
    echo ""
    echo "Press Enter to continue to next test..."
    read
done

echo "======================================"
echo "All tests completed!"
echo ""
echo "To test with your own scrambles, run:"
echo "  ./cube-solver"
echo ""
echo "For random scrambles, you can generate them using the solver's"
echo "internal random scramble generation or use online scramble generators."
echo "======================================"
