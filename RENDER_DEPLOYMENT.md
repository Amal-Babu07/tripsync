# 🚀 TripSync Render Deployment Guide

## 📋 Prerequisites

- GitHub account with your TripSync repository
- Render account (free) - https://render.com

## 🗄️ Step 1: Deploy PostgreSQL Database

1. **Go to Render Dashboard:** https://dashboard.render.com
2. **Create New PostgreSQL:**
   - Click **"New +"** → **"PostgreSQL"**
   - **Name:** `tripsync-database`
   - **Database:** `tripsync_db`
   - **User:** `tripsync_user`
   - **Region:** Choose closest to you
   - **Plan:** Free (100MB storage, 90 days)
   - Click **"Create Database"**

3. **Copy Database Details:**
   - **Internal Database URL:** Copy this for backend
   - **External Database URL:** For external connections
   - Keep these safe - you'll need them!

## 🖥️ Step 2: Deploy Backend API

1. **Create New Web Service:**
   - Click **"New +"** → **"Web Service"**
   - **Connect Repository:** Select your GitHub `tripsync` repo
   - **Name:** `tripsync-backend`
   - **Region:** Same as database
   - **Branch:** `main`
   - **Root Directory:** `tripsync-backend`

2. **Build & Deploy Settings:**
   - **Runtime:** `Node`
   - **Build Command:** `npm install && npm run migrate`
   - **Start Command:** `npm start`
   - **Plan:** Free (750 hours/month)

3. **Environment Variables:**
   ```
   NODE_ENV=production
   PORT=10000
   DATABASE_URL=<your_postgres_internal_url>
   JWT_SECRET=your_super_secret_jwt_key_make_it_very_long_and_random_123456789
   ```

4. **Advanced Settings:**
   - **Health Check Path:** `/health`
   - **Auto-Deploy:** Yes

## 🌐 Step 3: Deploy Flutter Web

1. **Create Static Site:**
   - Click **"New +"** → **"Static Site"**
   - **Connect Repository:** Select your GitHub `tripsync` repo
   - **Name:** `tripsync-web`
   - **Branch:** `main`
   - **Root Directory:** Leave empty (root)

2. **Build Settings:**
   - **Build Command:** `flutter build web --release`
   - **Publish Directory:** `build/web`

3. **Environment Variables:**
   ```
   FLUTTER_WEB=true
   ```

## 🔧 Step 4: Update Flutter API URLs

After backend deployment, update your Flutter app:

1. **Get Backend URL:**
   - From Render dashboard: `https://tripsync-backend-xxxx.onrender.com`

2. **Update API URLs in Flutter:**
   ```dart
   // In lib/services/api_service.dart
   static const String baseUrl = 'https://tripsync-backend-xxxx.onrender.com/api';
   
   // In lib/main.dart - Replace all instances of:
   // 'http://192.168.4.218:3000/api'
   // with:
   // 'https://tripsync-backend-xxxx.onrender.com/api'
   ```

3. **Commit and Push:**
   ```bash
   git add .
   git commit -m "Update API URLs for Render deployment"
   git push
   ```

## 🧪 Step 5: Test Your Deployment

### 1. Test Backend Health:
```bash
curl https://tripsync-backend-xxxx.onrender.com/health
```

### 2. Test Database Connection:
```bash
curl https://tripsync-backend-xxxx.onrender.com/api/users
```

### 3. Test Admin Login:
- Visit: `https://tripsync-web-xxxx.onrender.com`
- Login with: `amal@admin.tripsync.com` / `admin123`

## 📊 Your Deployed URLs

After successful deployment:

- **🌐 Web App:** `https://tripsync-web-xxxx.onrender.com`
- **🖥️ Backend API:** `https://tripsync-backend-xxxx.onrender.com`
- **🗄️ Database:** Render PostgreSQL (managed)
- **📱 Android APK:** Build locally with `flutter build apk --release`

## 🔄 Auto-Deployment

✅ **Backend:** Auto-deploys on every push to `main` branch
✅ **Frontend:** Auto-deploys on every push to `main` branch  
✅ **Database:** Persistent PostgreSQL with automatic backups

## 🚨 Important Notes

### Free Tier Limitations:
- **Backend:** Sleeps after 15 minutes of inactivity
- **Database:** 100MB storage, expires after 90 days
- **Static Site:** Unlimited bandwidth

### Wake-up Time:
- First request after sleep takes ~30 seconds
- Subsequent requests are fast

### Database Backup:
- Render provides automatic backups
- Export data before 90-day expiry

## 🔧 Environment Variables Reference

### Backend Environment Variables:
```env
NODE_ENV=production
PORT=10000
DATABASE_URL=postgresql://tripsync_user:password@dpg-xxxxx-a.oregon-postgres.render.com/tripsync_db
JWT_SECRET=your_super_secret_jwt_key_make_it_very_long_and_random_123456789
```

## 🛠️ Troubleshooting

### Common Issues:

1. **Build Fails:**
   - Check build logs in Render dashboard
   - Verify `package.json` scripts
   - Ensure all dependencies are listed

2. **Database Connection Error:**
   - Verify `DATABASE_URL` is correct
   - Check database is running in Render dashboard
   - Ensure migrations ran successfully

3. **CORS Errors:**
   - Backend CORS is configured for all origins
   - Check API URLs in Flutter app

4. **App Sleeps:**
   - Free tier sleeps after 15 minutes
   - Use a service like UptimeRobot to ping every 14 minutes

### Build Logs:
- **Backend:** Dashboard → tripsync-backend → Logs
- **Frontend:** Dashboard → tripsync-web → Logs

## 🎯 Production Checklist

- ✅ Database deployed and accessible
- ✅ Backend API deployed with health check
- ✅ Environment variables configured
- ✅ Flutter web app deployed
- ✅ API URLs updated in Flutter
- ✅ Admin login working
- ✅ Auto-deployment enabled

## 🚀 Going Live

1. **Custom Domain (Optional):**
   - Add custom domain in Render dashboard
   - Update DNS settings
   - SSL certificate auto-generated

2. **Monitoring:**
   - Use Render dashboard for logs
   - Set up UptimeRobot for uptime monitoring

3. **Scaling:**
   - Upgrade to paid plans for:
     - No sleep mode
     - More database storage
     - Better performance

---

**🎉 Your TripSync app is now live on Render!**

**Backend:** `https://tripsync-backend-xxxx.onrender.com`
**Frontend:** `https://tripsync-web-xxxx.onrender.com`
