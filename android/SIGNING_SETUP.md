# Android App Signing Setup Guide

## Problem
Your app bundle is signed with the wrong key. Google Play expects:
- **Expected SHA1**: `34:9B:35:89:13:05:45:5C:24:5D:A0:ED:46:C4:EC:C4:81:14:30:4C`
- **Current SHA1**: `58:EA:FC:CE:0D:F3:69:D8:9F:44:18:98:0F:2E:AD:C4:29:A1:C7:4F`

## Solution Steps

### Step 1: Locate Your Correct Keystore

You need to find the keystore file that has the SHA1 fingerprint: `34:9B:35:89:13:05:45:5C:24:5D:A0:ED:46:C4:EC:C4:81:14:30:4C`

**Option A: Check if you have the keystore file**
- Look for `.jks` or `.keystore` files on your computer
- Common locations:
  - `android/app/upload-keystore.jks`
  - `~/.android/` directory
  - Your backup folders
  - Google Drive or other cloud storage

**Option B: Use the PowerShell script to check keystore fingerprints**
```powershell
cd android
.\check_keystore.ps1 -KeystorePath "path\to\your\keystore.jks" -StorePassword "your_password"
```

This will show you the SHA1 fingerprint of the keystore and tell you if it matches.

### Step 2: Create key.properties File

1. Copy the template file:
   ```powershell
   copy android\key.properties.template android\key.properties
   ```

2. Edit `android/key.properties` and fill in your keystore information:
   ```properties
   storeFile=upload-keystore.jks
   storePassword=YOUR_STORE_PASSWORD
   keyAlias=upload
   keyPassword=YOUR_KEY_PASSWORD
   ```

   **Important**: 
   - The `storeFile` path should be relative to the `android/` directory
   - If your keystore is at `android/upload-keystore.jks`, use `upload-keystore.jks`
   - If it's elsewhere, use a relative path like `../keystores/upload-keystore.jks`

3. **DO NOT commit `key.properties` to version control!**
   - Add it to `.gitignore`:
     ```
     android/key.properties
     ```

### Step 3: Place Your Keystore File

Place your keystore file (the one with the correct SHA1) in the `android/` directory, or update the path in `key.properties` to point to its location.

### Step 4: Build and Verify

1. Build your app bundle:
   ```bash
   flutter build appbundle --release
   ```

2. Verify the SHA1 fingerprint of the generated bundle:
   ```powershell
   # You can use jarsigner or apksigner to verify
   # Or use the Google Play Console to check the uploaded bundle
   ```

### Step 5: Upload to Google Play

Once you've built the app bundle with the correct keystore, upload it to Google Play Console.

## Troubleshooting

### If you can't find the correct keystore:

1. **Check Google Play Console**: 
   - Go to your app in Google Play Console
   - Navigate to Release > Setup > App signing
   - Check if Google is managing your app signing key (App Signing by Google Play)
   - If so, you might need to use the upload key, not the app signing key

2. **Check your backup locations**:
   - Check your backup drives
   - Check cloud storage (Google Drive, Dropbox, etc.)
   - Check your email for keystore files you may have sent to yourself

3. **Contact your team**: If this is a team project, ask other team members if they have the keystore

### If you still have issues:

- Make sure `key.properties` is in the `android/` directory (not `android/app/`)
- Verify the keystore path in `key.properties` is correct
- Check that the keystore file exists at the specified path
- Verify the passwords are correct
- Make sure you're building with `--release` flag

## Security Notes

⚠️ **IMPORTANT**: 
- Never commit `key.properties` or keystore files to version control
- Keep secure backups of your keystore file and passwords
- Store passwords in a secure password manager
- If you lose your keystore, you won't be able to update your app on Google Play





