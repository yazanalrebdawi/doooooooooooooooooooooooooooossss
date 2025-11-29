# How to Reset Your Upload Key in Google Play Console

Since you've faced this issue before, here's how to reset your upload key:

## Step-by-Step Guide

### 1. Go to Google Play Console
- Navigate to: https://play.google.com/console
- Select your app: **One Door** (com.onedoor.doos)

### 2. Navigate to App Signing
- Go to: **Release** → **Setup** → **App signing**

### 3. Check if App Signing by Google Play is Enabled
- Look for "App Signing by Google Play" section
- If you see this, Google manages your app signing key
- You only need to reset the **upload key**

### 4. Request Upload Key Reset
- Scroll down to **"Upload key certificate"** section
- Click **"Request upload key reset"** button
- Follow the instructions to:
  - Upload your new upload key certificate
  - Verify your identity
  - Wait for Google's approval (usually 24-48 hours)

### 5. Generate Certificate for Upload Key Reset

To generate the certificate file needed for the reset request, run:

```powershell
cd android
keytool -export -rfc -keystore upload-keystore.jks -alias upload -file upload_certificate.pem -storepass android
```

This creates `upload_certificate.pem` which you'll upload to Google Play Console.

### 6. After Approval
Once Google approves your upload key reset:
- Your new keystore (the one we just created) will be accepted
- You can upload new app bundles signed with this keystore
- The SHA1 will be: `47:30:CC:82:5C:AB:21:3D:D2:E5:DD:DC:B2:9A:C1:F0:D9:31:43:3C`

## Alternative: Contact Google Play Support

If you can't find the "Request upload key reset" option:

1. Go to: https://support.google.com/googleplay/android-developer/contact/other
2. Select "App signing and keys" as the issue type
3. Explain that you lost your upload key and need to reset it
4. Provide:
   - Your app package name: `com.onedoor.doos`
   - The expected SHA1: `34:9B:35:89:13:05:45:5C:24:5D:A0:ED:46:C4:EC:C4:81:14:30:4C`
   - The new upload certificate (upload_certificate.pem)

## Important Notes

⚠️ **After resetting the upload key:**
- Keep the new keystore file safe: `android/upload-keystore.jks`
- Store the passwords securely (currently: `android` - consider changing them)
- Make backups of the keystore file
- The keystore is already configured in `key.properties`

✅ **Once the upload key is reset, you can:**
- Build new app bundles: `flutter build appbundle --release`
- Upload them to Google Play Console
- They will be accepted because the upload key matches





