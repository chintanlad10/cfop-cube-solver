# CFOP Cube Solver

This is a C++ application to solve a Rubik's Cube using the CFOP method. The project includes both a command-line interface and an interactive 3D web application built with WebAssembly and Three.js.

The method used by this program is the CFOP method, which you can learn about [here](LINK_TO_BE_PROVIDED).

The average solution length is around 70 moves, using half turn metric. While this is far from the optimal number of 20, it isn't terribly far off from what human speedcubers can achieve using CFOP, which is usually around 50-60.

## How it works

The solver implements the CFOP method in four distinct phases:

1. **Cross**: Solves the bottom layer cross (4 edge pieces)
2. **F2L**: First Two Layers - solves corner-edge pairs simultaneously  
3. **OLL**: Orientation of Last Layer - makes the top face a solid color
4. **PLL**: Permutation of Last Layer - positions the final pieces correctly

When you run the program, you will be prompted to enter a scramble.

Scrambles should follow standard cube notation, which you can read about [here](LINK_TO_BE_PROVIDED).

The cube can be in any orientation at the time of the scramble, and whichever color ends up at the bottom once the cube is finished scrambling is chosen to be the cross color.

The program will output solutions showing each step of the CFOP method. The web version provides an interactive 3D visualization of the solving process.

## How to use it

### Command Line

To use the command-line version:

1. Build the executable using `make`
2. Run `./cube-solver`
3. Enter a scramble using standard notation (e.g., R U R' F R F')

### Web Version

This project has been compiled to WebAssembly and features an interactive 3D Rubik's Cube interface.

The web version includes:
- Interactive 3D cube manipulation
- Visual step-by-step solving
- Custom scramble input
- Real-time cube state updates

### Compilation

To compile this program yourself, you'll need `make` and the `g++` compiler.

If you have them, simply run `make` from the project's root directory.

For the web version, you'll also need the Emscripten SDK installed. Once installed, run `make web` to build the WebAssembly module.
