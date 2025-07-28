#!/bin/bash

# Web Version Test Script for CFOP Cube Solver

echo "🎲 CFOP Cube Solver - Web Version Test"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "docs/index.html" ]; then
    echo "❌ Error: docs/index.html not found. Please run from project root."
    exit 1
fi

echo "✅ Found web files in docs/ directory"

# Check for required files
echo ""
echo "Checking required files:"

required_files=(
    "docs/index.html"
    "docs/style.css"
    "docs/js/cube/main.js"
    "docs/js/cube/Cube.js"
    "docs/js/cube/Constants.js"
    "docs/README.md"
    "docs/package.json"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
    fi
done

# Check WebAssembly files
echo ""
echo "Checking WebAssembly files:"
if [ -f "docs/js/cube/solver/cube-solver.js" ] && [ -f "docs/js/cube/solver/cube-solver.wasm" ]; then
    echo "✅ WebAssembly files present"
    echo "   - Size of .js file: $(du -h docs/js/cube/solver/cube-solver.js | cut -f1)"
    echo "   - Size of .wasm file: $(du -h docs/js/cube/solver/cube-solver.wasm | cut -f1)"
else
    echo "⚠️  WebAssembly files missing - run 'make web' to build"
    echo "   You can still test the 3D interface without the solver"
fi

# Check if we can start a local server
echo ""
echo "Testing local server capabilities:"

if command -v python3 >/dev/null 2>&1; then
    echo "✅ Python 3 available for local server"
elif command -v python >/dev/null 2>&1; then
    echo "✅ Python available for local server"
elif command -v node >/dev/null 2>&1; then
    echo "✅ Node.js available for local server"
else
    echo "⚠️  No local server option found. Install Python or Node.js"
fi

# Check for Emscripten (for WASM building)
echo ""
echo "Checking build tools:"

if command -v em++ >/dev/null 2>&1; then
    echo "✅ Emscripten available for WebAssembly compilation"
    echo "   Version: $(em++ --version | head -n1)"
else
    echo "⚠️  Emscripten not found. Run 'make install-emsdk' to install"
fi

# Validate HTML and check for common issues
echo ""
echo "Validating web files:"

# Check if HTML has required elements
if grep -q "three-container" docs/index.html; then
    echo "✅ HTML contains three-container div"
else
    echo "❌ HTML missing three-container div"
fi

if grep -q "solve-button" docs/index.html; then
    echo "✅ HTML contains solve button"
else
    echo "❌ HTML missing solve button"
fi

# Check CSS for responsive design
if grep -q "@media" docs/style.css; then
    echo "✅ CSS includes responsive design"
else
    echo "⚠️  CSS may not be mobile-friendly"
fi

# Check JavaScript modules
if grep -q "type=\"module\"" docs/index.html; then
    echo "✅ JavaScript uses ES6 modules"
else
    echo "⚠️  JavaScript may not use modern module system"
fi

# Final recommendations
echo ""
echo "🚀 Next Steps:"
echo "=============="

if [ ! -f "docs/js/cube/solver/cube-solver.wasm" ]; then
    echo "1. Build WebAssembly: make web"
fi

echo "2. Test locally: make serve-web"
echo "3. Deploy to GitHub Pages, Netlify, or Vercel"
echo "4. Visit DEPLOYMENT.md for detailed deployment instructions"

echo ""
echo "Quick local test:"
echo "cd docs && python3 -m http.server 8000"
echo "Then visit: http://localhost:8000"

echo ""
echo "Test completed! 🎯"
