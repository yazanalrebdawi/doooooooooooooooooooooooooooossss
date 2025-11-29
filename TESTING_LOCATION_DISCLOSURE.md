# Testing Location Disclosure - Step by Step Guide

## 🎯 How to See the Location Permission Disclosure

### Method 1: Fresh Install (Recommended)

1. **Uninstall the app completely**
   ```bash
   flutter clean
   flutter install
   ```

2. **Open the app and sign in**
   - Complete the login process
   - Navigate to home screen

3. **Click on the Services tab** (second icon in bottom navigation)

4. **🎉 The full-screen location disclosure should appear automatically!**

---

### Method 2: Revoke Permission on Existing Install

1. **On your device, go to:**
   - Settings → Apps → Dooss
   - Tap "Permissions"
   - Tap "Location"
   - Select **"Don't allow"**

2. **Force stop the app:**
   - Settings → Apps → Dooss → Force Stop

3. **Open the app again**

4. **Sign in (if needed)**

5. **Navigate to Services tab**

6. **🎉 The full-screen disclosure should appear automatically!**

---

### Method 3: Using ADB (Android Debug Bridge)

```bash
# Revoke location permission
adb shell pm revoke com.onedoor.doos android.permission.ACCESS_FINE_LOCATION
adb shell pm revoke com.onedoor.doos android.permission.ACCESS_COARSE_LOCATION

# Kill and restart the app
adb shell am force-stop com.onedoor.doos
adb shell am start -n com.onedoor.doos/.MainActivity
```

Then navigate to Services tab - disclosure should appear.

---

## 📱 What You Should See

### Full-Screen Disclosure Page:
```
┌─────────────────────────────┐
│    [Location Icon]          │
│  Location Permission        │
│      Required               │
├─────────────────────────────┤
│                             │
│ Dooss needs access to your  │
│ location to show nearby...  │
│                             │
│ ┌─────────────────────────┐ │
│ │ What Data We Collect    │ │
│ │ • GPS location...       │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ Why We Need Location    │ │
│ │ • Show nearby services  │ │
│ │ • Calculate distances   │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ Privacy Commitment      │ │
│ │ • View Privacy Policy   │ │
│ └─────────────────────────┘ │
│                             │
│ [Allow Location Access]     │
│ [Don't Allow]               │
└─────────────────────────────┘
```

### After Clicking "Allow Location Access":
- System permission dialog appears
- Select "While using the app"
- Services load automatically

---

## ✅ Verification Checklist

- [ ] App opens successfully
- [ ] Sign in works
- [ ] Navigate to Services tab
- [ ] **Full-screen disclosure appears automatically**
- [ ] Disclosure shows all required information
- [ ] Privacy Policy link is visible and clickable
- [ ] "Allow Location Access" button works
- [ ] System permission dialog appears after disclosure
- [ ] Services load after granting permission

---

## 🐛 Troubleshooting

### Disclosure Doesn't Appear?

**Possible Cause**: Location permission is already granted

**Solution**: Revoke permission first:
```bash
Settings → Apps → Dooss → Permissions → Location → Don't allow
```

### App Crashes?

**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📸 Screenshots for Google Play Appeal

When disclosure appears, take screenshots showing:
1. ✅ Full-screen disclosure page
2. ✅ Clear explanation of data usage
3. ✅ Privacy Policy link
4. ✅ Allow/Don't Allow buttons

These prove compliance to Google Play reviewers.

---

## 🎬 Video Recording (Recommended)

Record a screen video showing:
1. Fresh app install
2. Sign in process
3. Navigate to Services tab
4. **Disclosure appears automatically**
5. Read through disclosure
6. Click "Allow Location Access"
7. System dialog appears
8. Services load successfully

This video will be valuable if you need to appeal a review decision.

---

**Last Updated**: November 28, 2025  
**Status**: Location disclosure configured to show automatically ✅






