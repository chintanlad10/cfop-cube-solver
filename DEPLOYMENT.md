# Web Deployment Guide - CFOP Cube Solver

This guide covers multiple deployment options for your CFOP Cube Solver web application.

## Quick Start

### 1. Local Development
```bash
# Build the WebAssembly module (requires Emscripten)
make web

# Start local server
make serve-web

# Visit http://localhost:8000
```

### 2. GitHub Pages (Recommended for beginners)
```bash
# 1. Push your code to GitHub
git add docs/
git commit -m "Add web version"
git push origin main

# 2. Enable GitHub Pages
# - Go to repository Settings
# - Scroll to "Pages" section  
# - Select "Deploy from a branch"
# - Choose "main" branch and "/docs" folder
# - Save and wait for deployment

# Your site will be available at:
# https://your-username.github.io/your-repository-name
```

## Deployment Platforms

### GitHub Pages
**Best for**: Free hosting, automatic deployment, simple setup

**Steps**:
1. Ensure your web files are in the `docs/` folder
2. Push to GitHub repository
3. Enable Pages in repository settings
4. Select `docs` folder as source

**Pros**: 
- Free
- Automatic deployment on push
- Custom domain support
- HTTPS included

**Cons**:
- Public repositories only (for free tier)
- Static files only

### Netlify
**Best for**: Advanced features, custom build processes, form handling

**Setup**:
```bash
# 1. Install Netlify CLI
npm install -g netlify-cli

# 2. Login to Netlify
netlify login

# 3. Deploy from docs folder
cd docs
netlify deploy --prod --dir=.
```

**Configuration**: `docs/netlify.toml` (already included)

**Pros**:
- Free tier available
- Advanced features (forms, functions, analytics)
- Automatic HTTPS
- Branch previews
- Custom headers and redirects

### Vercel
**Best for**: Next.js projects, serverless functions, global CDN

**Setup**:
```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Deploy from docs folder
cd docs
vercel --prod
```

**Configuration**: `docs/vercel.json` (already included)

**Pros**:
- Excellent performance
- Global CDN
- Serverless functions
- Automatic HTTPS
- Preview deployments

### Firebase Hosting
**Best for**: Google ecosystem integration, real-time features

**Setup**:
```bash
# 1. Install Firebase CLI
npm install -g firebase-tools

# 2. Login and initialize
firebase login
firebase init hosting

# 3. Configure firebase.json
{
  "hosting": {
    "public": "docs",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
  }
}

# 4. Deploy
firebase deploy
```

### AWS S3 + CloudFront
**Best for**: Enterprise applications, full AWS integration

**Setup**:
```bash
# 1. Install AWS CLI
pip install awscli

# 2. Configure credentials
aws configure

# 3. Create S3 bucket
aws s3 mb s3://your-cube-solver-bucket

# 4. Upload files
aws s3 sync docs/ s3://your-cube-solver-bucket --delete

# 5. Enable static website hosting
aws s3 website s3://your-cube-solver-bucket --index-document index.html
```

## Building WebAssembly

### Prerequisites
```bash
# Install Emscripten SDK
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
```

### Build Commands
```bash
# Development build (with debugging)
make web-dev

# Production build (optimized)
make web

# Manual build
em++ Web.cpp Cube/*.cpp Solver/*.cpp Util/*.cpp \
  --bind -o docs/js/cube/solver/cube-solver.js \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' \
  -s MODULARIZE=1 \
  -s EXPORT_NAME='CubeSolverModule' \
  -ICube -ISolver -IUtil \
  --closure 1 -O3
```

## Performance Optimization

### WebAssembly Optimization
```bash
# Optimized build flags
-O3                          # Maximum optimization
--closure 1                  # Google Closure Compiler
-s MODULARIZE=1             # ES6 module export
-s ALLOW_MEMORY_GROWTH=1    # Dynamic memory
--emit-tsd cube-solver.d.ts # TypeScript definitions
```

### Asset Optimization
```bash
# Compress images (if any)
npm install -g imagemin-cli
imagemin assets/*.png --out-dir=assets/compressed

# Minify CSS (optional)
npm install -g clean-css-cli
cleancss style.css -o style.min.css

# Compress files for better transfer
gzip -9 -c docs/js/cube/solver/cube-solver.wasm > docs/js/cube/solver/cube-solver.wasm.gz
```

## CI/CD Automation

### GitHub Actions
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Emscripten
      uses: mymindstorm/setup-emsdk@v11
      with:
        version: latest
    
    - name: Build WebAssembly
      run: make web
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs
```

### Netlify CI
Netlify automatically deploys when you push to your connected repository.

## Custom Domain Setup

### GitHub Pages
1. Add `CNAME` file to `docs/` folder with your domain
2. Configure DNS A records to point to GitHub's IPs:
   - 185.199.108.153
   - 185.199.109.153  
   - 185.199.110.153
   - 185.199.111.153

### Netlify
1. Add domain in Netlify dashboard
2. Configure DNS to point to Netlify's nameservers

### Cloudflare (Recommended)
1. Add your site to Cloudflare
2. Update nameservers at your domain registrar
3. Configure Page Rules for caching optimization

## Security Headers

### Content Security Policy
Add to your HTML `<head>`:
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' 'unsafe-eval' https://unpkg.com;
  style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
  font-src https://fonts.gstatic.com;
  connect-src 'self';
  img-src 'self' data:;
  worker-src 'self' blob:;
">
```

### HTTPS Configuration
All modern deployment platforms provide automatic HTTPS. For custom deployments:
```bash
# Let's Encrypt with Certbot
sudo apt install certbot
sudo certbot --nginx -d your-domain.com
```

## Monitoring and Analytics

### Google Analytics
Add to your HTML:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_TRACKING_ID');
</script>
```

### Performance Monitoring
```javascript
// Add to your main.js
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js');
}

// Monitor WebAssembly loading
console.time('WASM Load Time');
// ... after WASM loads
console.timeEnd('WASM Load Time');
```

## Troubleshooting

### Common Issues

**WASM not loading**:
- Check MIME type is set to `application/wasm`
- Ensure CORS headers are configured correctly
- Verify file paths are correct

**Three.js import errors**:
- Use CDN URLs for Three.js modules
- Check version compatibility
- Verify ES6 module support

**Performance issues**:
- Enable gzip compression
- Use WebAssembly optimizations
- Implement service worker caching

### Debug Commands
```bash
# Check file sizes
ls -la docs/js/cube/solver/

# Test WebAssembly module
node -e "require('./docs/js/cube/solver/cube-solver.js')"

# Verify WASM integrity
file docs/js/cube/solver/cube-solver.wasm
```

## Production Checklist

- [ ] WebAssembly module built and optimized
- [ ] All file paths are relative and correct
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Performance optimizations applied
- [ ] Analytics and monitoring set up
- [ ] Custom domain configured (if needed)
- [ ] Backup and recovery plan in place
- [ ] Load testing completed
- [ ] Cross-browser testing done

Your CFOP Cube Solver is now ready for the web! 🎲✨
