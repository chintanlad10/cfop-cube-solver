# CFOP Method Implementation Guide

## What is CFOP?

CFOP (Cross, F2L, OLL, PLL) is one of the most popular methods for solving a Rubik's Cube, especially among speedcubers. It breaks down the solve into four distinct stages:

### 1. Cross
- **Goal**: Solve the cross on one face (usually the bottom)
- **Implementation**: `SolverCross.cpp` and `SolverCross.h`
- **Strategy**: Place the four edge pieces of one color in their correct positions
- **Typical Move Count**: 6-8 moves

### 2. F2L (First Two Layers)
- **Goal**: Simultaneously solve the bottom two layers by pairing corners with edges
- **Implementation**: `SolverF2L.cpp` and `SolverF2L.h`
- **Strategy**: Find corner-edge pairs and insert them into their slots
- **Typical Move Count**: 25-35 moves
- **Number of Cases**: 42 basic F2L cases

### 3. OLL (Orientation of Last Layer)
- **Goal**: Orient all pieces on the last layer (make the top face uniform color)
- **Implementation**: `SolverOLL.cpp` and `SolverOLL.h`
- **Strategy**: Apply algorithms to flip edges and rotate corners until top face is solved
- **Typical Move Count**: 8-12 moves
- **Number of Cases**: 57 OLL algorithms

### 4. PLL (Permutation of Last Layer)
- **Goal**: Permute the pieces on the last layer to their correct positions
- **Implementation**: `SolverPLL.cpp` and `SolverPLL.h`
- **Strategy**: Move pieces to their final positions while maintaining orientation
- **Typical Move Count**: 8-15 moves
- **Number of Cases**: 21 PLL algorithms

## Code Architecture

### Core Classes

#### `Cube` Class (`Cube/Cube.h`, `Cube/Cube.cpp`)
- Represents the complete state of a Rubik's Cube
- Uses efficient bit manipulation for state storage
- Handles move execution and state tracking
- Provides methods for checking solve status

#### `Move` Class (`Cube/Move.h`, `Cube/Move.cpp`)
- Represents individual cube moves (U, R, F, etc.)
- Handles move parsing from notation strings
- Supports basic moves, prime moves, and double moves

#### `Solver` Class (`Solver/Solver.h`, `Solver/Solver.cpp`)
- Main solver controller that orchestrates the CFOP method
- Integrates all four solving stages
- Handles solution optimization and move sequence cleanup
- Provides the main solving interface

### Solving Stages

#### Cross Solver (`SolverCross.h/cpp`)
```cpp
// Key functions:
- solveCross(): Main cross solving algorithm
- findCrossEdges(): Locate cross pieces
- placeCrossEdge(): Position individual cross pieces
```

#### F2L Solver (`SolverF2L.h/cpp`)
```cpp
// Key functions:
- solveF2L(): Main F2L solving algorithm
- findF2LPair(): Locate corner-edge pairs
- insertF2LPair(): Insert pairs into slots
```

#### OLL Solver (`SolverOLL.h/cpp`)
```cpp
// Key functions:
- solveOLL(): Main OLL solving algorithm
- recognizeOLLCase(): Pattern recognition for OLL
- applyOLLAlgorithm(): Execute specific OLL algorithms
```

#### PLL Solver (`SolverPLL.h/cpp`)
```cpp
// Key functions:
- solvePLL(): Main PLL solving algorithm
- recognizePLLCase(): Pattern recognition for PLL
- applyPLLAlgorithm(): Execute specific PLL algorithms
```

## Algorithm Implementation Details

### State Representation
The cube state is efficiently stored using bit manipulation:
- Each face uses a 64-bit integer
- 8 stickers per face (excluding fixed centers)
- 3 bits per sticker for color encoding
- Total storage: 7 × 64-bit integers

### Move Engine
The move system supports:
- **Basic moves**: U, D, R, L, F, B (90° clockwise)
- **Prime moves**: U', D', R', L', F', B' (90° counterclockwise)  
- **Double moves**: U2, D2, R2, L2, F2, B2 (180°)
- **Wide moves**: u, d, r, l, f, b (for advanced algorithms)

### Pattern Recognition
Each solving stage uses pattern recognition:
- **Cross**: Edge orientation and position analysis
- **F2L**: Corner-edge relationship detection
- **OLL**: Last layer edge and corner orientation patterns
- **PLL**: Last layer permutation patterns

### Algorithm Database
The solver includes comprehensive algorithm sets:
- **F2L**: 42 intuitive and algorithmic cases
- **OLL**: 57 complete orientation algorithms
- **PLL**: 21 permutation algorithms

## Performance Characteristics

### Solution Quality
- **Average Length**: ~70 moves (half-turn metric)
- **Optimal Range**: 20-120 moves depending on scramble
- **Consistency**: Very reliable, solves any valid scramble

### Time Complexity
- **Cross**: O(n) where n is search depth
- **F2L**: O(n²) for pair finding and insertion
- **OLL**: O(1) with precomputed algorithms
- **PLL**: O(1) with precomputed algorithms

### Memory Usage
- Compact cube representation
- Precomputed algorithm tables
- Minimal dynamic allocation

## Usage Examples

### Basic Usage
```cpp
#include "Solver.h"

Cube cube;
cube.parseScramble("R U R' U' R' F R2 U' R' U' R U R' F'");

Solver solver;
std::vector<Move> solution = solver.solve(cube);
```

### Advanced Usage
```cpp
// Custom solving with step-by-step output
Solver solver;
std::vector<Move> crossSolution = solver.solveCross(cube);
std::vector<Move> f2lSolution = solver.solveF2L(cube);
std::vector<Move> ollSolution = solver.solveOLL(cube);
std::vector<Move> pllSolution = solver.solvePLL(cube);
```

## Building and Running

### Compilation
```bash
make debug    # Debug build with symbols
make release  # Optimized build
make clean    # Clean build artifacts
```

### Testing
```bash
./cube-solver                    # Interactive mode
echo "R U R' U'" | ./cube-solver # Pipe scramble
./test_solver.sh                 # Run test suite
./example.sh                     # Run examples
```

## Extending the Solver

### Adding New Algorithms
1. Update the appropriate solver class (OLL/PLL)
2. Add algorithm to the database
3. Update pattern recognition
4. Test with known cases

### Performance Optimization
1. **Pruning**: Add better move pruning
2. **Lookahead**: Implement cross-to-F2L lookahead
3. **Recognition**: Optimize pattern recognition
4. **Algorithms**: Use more efficient algorithm variants

### Additional Methods
The architecture supports adding other solving methods:
- **ZBLL**: Combine OLL+PLL recognition
- **Roux**: Block-building method
- **ZZ**: Edge orientation first method
- **Petrus**: 2x2x2 block + expansion method

This implementation provides a solid foundation for understanding both the CFOP method and efficient cube-solving algorithms in general.
