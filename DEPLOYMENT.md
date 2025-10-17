# VISTA Mobile App - Netlify Deployment Guide

## 🚀 Quick Deploy to Netlify

### Option 1: Automatic Deploy (Recommended)
1. Connect your GitHub repository to Netlify
2. Set build command: `flutter build web --release`
3. Set publish directory: `build/web`
4. Deploy!

### Option 2: Manual Deploy
1. Run the build script: `./build.sh` (Linux/Mac) or manually build
2. Upload the `build/web` folder to Netlify

## 📁 Files for Deployment

- `netlify.toml` - Netlify configuration
- `_redirects` - URL routing for SPA
- `build.sh` - Build script
- `build/web/` - Production build output

## 🔧 Build Commands

```bash
# Install dependencies
flutter pub get

# Build for production
flutter build web --release

# The deployable files will be in build/web/
```

## 🌐 Environment Variables

No environment variables required for basic deployment.

## 📱 Features

- ✅ Responsive design
- ✅ PWA ready
- ✅ Optimized for web
- ✅ Single Page Application routing
- ✅ Asset caching
- ✅ Security headers

## 🔗 Live Demo

After deployment, your app will be available at:
`https://your-app-name.netlify.app`

## 🛠 Troubleshooting

1. **Blank page**: Check browser console for errors
2. **Routing issues**: Ensure `_redirects` file is in build output
3. **Assets not loading**: Check asset paths in `pubspec.yaml`

## 📊 Performance

- Optimized build size
- Lazy loading
- Asset compression
- CDN delivery via Netlify
