# 🚀 TripSync Deployment Guide

## 📋 Prerequisites

- GitHub account
- Railway account (free)
- Netlify account (free) - for web version

## 🗄️ Step 1: Deploy Database (Railway)

1. **Go to Railway:** https://railway.app
2. **Sign up/Login** with GitHub
3. **Create New Project** → **Deploy PostgreSQL**
4. **Copy Database URL** from Railway dashboard
5. **Note:** Free tier includes 500MB storage

## 🖥️ Step 2: Deploy Backend (Railway)

1. **In Railway Dashboard:**
   - Click **"New Project"**
   - Select **"Deploy from GitHub repo"**
   - Choose your `tripsync` repository
   - Select the `tripsync-backend` folder

2. **Set Environment Variables:**
   ```
   DATABASE_URL=<your_railway_postgres_url>
   JWT_SECRET=your_super_secret_jwt_key_make_it_very_long_and_random
   NODE_ENV=production
   PORT=3000
   ```

3. **Deploy Settings:**
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Root Directory:** `tripsync-backend`

4. **Get Your Backend URL:**
   - Railway will provide a URL like: `https://your-app-name.up.railway.app`

## 📱 Step 3: Update Flutter App

1. **Update API URLs in Flutter:**
   ```dart
   // In lib/services/api_service.dart
   static const String baseUrl = 'https://your-railway-app.up.railway.app/api';
   
   // In lib/main.dart - Replace all instances of:
   // 'http://192.168.4.218:3000/api' 
   // with:
   // 'https://your-railway-app.up.railway.app/api'
   ```

## 🌐 Step 4: Deploy Flutter Web (Netlify)

1. **Build Flutter Web:**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Netlify:**
   - Go to https://netlify.com
   - **New site from Git** → Connect GitHub
   - Select your `tripsync` repository
   - **Build settings:**
     - Build command: `flutter build web --release`
     - Publish directory: `build/web`

3. **Get Your Web URL:**
   - Netlify provides: `https://your-app-name.netlify.app`

## 📱 Step 5: Build Android APK

1. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```

2. **APK Location:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Upload to GitHub Releases:**
   - Go to your GitHub repository
   - **Releases** → **Create a new release**
   - Upload the APK file
   - Users can download and install

## 🔧 Environment Variables for Railway

### Backend Environment Variables:
```env
DATABASE_URL=postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway
JWT_SECRET=super_secret_jwt_key_for_production_make_it_very_long_and_random_123456789
NODE_ENV=production
PORT=3000
```

## 🧪 Testing Your Deployment

### 1. Test Backend API:
```bash
curl https://your-railway-app.up.railway.app/health
```

### 2. Test Database Connection:
```bash
curl https://your-railway-app.up.railway.app/api/users
```

### 3. Test Flutter Web:
- Visit: `https://your-app-name.netlify.app`
- Try login with admin credentials

## 📊 Monitoring & Logs

### Railway Logs:
- **Dashboard** → **Your Project** → **Deployments** → **View Logs**

### Netlify Logs:
- **Site Dashboard** → **Functions** → **View Logs**

## 🔄 Auto-Deployment

### Backend (Railway):
- **Auto-deploys** on every push to `main` branch
- **Environment:** Production
- **Database:** Persistent PostgreSQL

### Frontend (Netlify):
- **Auto-deploys** on every push to `main` branch
- **Build:** Automatic Flutter web build
- **CDN:** Global content delivery

## 🎯 Production URLs

After deployment, you'll have:

- **Backend API:** `https://your-railway-app.up.railway.app`
- **Web App:** `https://your-app-name.netlify.app`
- **Android APK:** GitHub Releases download
- **Database:** Railway PostgreSQL

## 🔐 Security Checklist

- ✅ JWT secrets are secure and random
- ✅ Database credentials are not in code
- ✅ CORS is properly configured
- ✅ Rate limiting is enabled
- ✅ HTTPS is enforced
- ✅ Environment variables are set

## 🚨 Troubleshooting

### Common Issues:

1. **Database Connection Error:**
   - Check `DATABASE_URL` in Railway environment variables
   - Ensure PostgreSQL service is running

2. **CORS Error in Flutter Web:**
   - Update CORS settings in backend
   - Check API URL in Flutter app

3. **Build Failures:**
   - Check build logs in Railway/Netlify
   - Verify all dependencies are listed

4. **API Not Found:**
   - Verify backend deployment is successful
   - Check API endpoint URLs

## 📞 Support

If you encounter issues:
1. Check Railway/Netlify deployment logs
2. Verify environment variables
3. Test API endpoints manually
4. Check GitHub repository settings

---

**🎉 Your TripSync app is now live in production!**
