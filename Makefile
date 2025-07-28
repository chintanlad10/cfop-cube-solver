CC = g++
FILES = $(wildcard Cube/*.cpp Solver/*.cpp Util/*.cpp)
CFLAGS = -std=c++14 -Wall -ICube -ISolver -IUtil
INCLUDE_FLAGS = -ICube -ISolver -IUtil

ifeq ($(OS),Windows_NT)
	RM = cmd /C del
	TARGET = cube-solver.exe
	OBJ_FILES = *.o
else
	RM = rm -f
	TARGET = cube-solver
	OBJ_FILES = *.o
endif

all: debug

debug: Main.cpp $(FILES)
	$(CC) $(CFLAGS) -g -c Main.cpp $(FILES) $(INCLUDE_FLAGS)
	$(CC) *.o -o $(TARGET)

release: Main.cpp $(FILES)
	$(CC) $(CFLAGS) -O3 -DNDEBUG -c Main.cpp $(FILES) $(INCLUDE_FLAGS)
	$(CC) *.o -o $(TARGET)

web: Web.cpp $(FILES)
	@echo "Building WebAssembly version..."
	@if command -v em++ >/dev/null 2>&1; then \
		em++ Web.cpp $(FILES) --bind -o docs/js/cube/solver/cube-solver.js \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' \
		-s MODULARIZE=1 \
		-s EXPORT_NAME='CubeSolverModule' \
		$(INCLUDE_FLAGS) \
		--closure 1 \
		-O3; \
		echo "WebAssembly build complete!"; \
	else \
		echo "Error: Emscripten not found. Please install Emscripten SDK first."; \
		echo "Visit: https://emscripten.org/docs/getting_started/downloads.html"; \
		exit 1; \
	fi

web-dev: Web.cpp $(FILES)
	@echo "Building WebAssembly development version..."
	@if command -v em++ >/dev/null 2>&1; then \
		em++ Web.cpp $(FILES) --bind -o docs/js/cube/solver/cube-solver.js \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' \
		-s MODULARIZE=1 \
		-s EXPORT_NAME='CubeSolverModule' \
		-s ASSERTIONS=1 \
		-s SAFE_HEAP=1 \
		$(INCLUDE_FLAGS) \
		-g; \
		echo "WebAssembly development build complete!"; \
	else \
		echo "Error: Emscripten not found. Please install Emscripten SDK first."; \
		exit 1; \
	fi

serve-web:
	@echo "Starting local web server..."
	@if command -v python3 >/dev/null 2>&1; then \
		cd docs && python3 -m http.server 8000; \
	elif command -v python >/dev/null 2>&1; then \
		cd docs && python -m http.server 8000; \
	elif command -v npx >/dev/null 2>&1; then \
		cd docs && npx serve -l 8000; \
	else \
		echo "Error: No suitable server found. Please install Python or Node.js"; \
		exit 1; \
	fi

test: debug
	./$(TARGET)

clean:
	$(RM) $(OBJ_FILES) $(TARGET)

clean-web:
	$(RM) docs/js/cube/solver/cube-solver.js docs/js/cube/solver/cube-solver.wasm

clean-all: clean clean-web

install-emsdk:
	@echo "Installing Emscripten SDK..."
	@if [ ! -d "emsdk" ]; then \
		git clone https://github.com/emscripten-core/emsdk.git; \
		cd emsdk && ./emsdk install latest && ./emsdk activate latest; \
		echo "Emscripten installed! Run 'source emsdk/emsdk_env.sh' to activate."; \
	else \
		echo "Emscripten SDK already exists. Run 'cd emsdk && ./emsdk update' to update."; \
	fi

help:
	@echo "Available targets:"
	@echo "  debug       - Build debug version of console application"
	@echo "  release     - Build optimized version of console application"
	@echo "  web         - Build WebAssembly version for web deployment"
	@echo "  web-dev     - Build WebAssembly development version with debugging"
	@echo "  serve-web   - Start local web server to test web version"
	@echo "  test        - Build and run console application"
	@echo "  clean       - Remove console build artifacts"
	@echo "  clean-web   - Remove WebAssembly build artifacts"
	@echo "  clean-all   - Remove all build artifacts"
	@echo "  install-emsdk - Install Emscripten SDK for WebAssembly compilation"
	@echo "  help        - Show this help message"

.PHONY: all debug release web web-dev serve-web test clean clean-web clean-all install-emsdk help
