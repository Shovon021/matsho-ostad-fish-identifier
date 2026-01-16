// ⚠️ IMPORTANT: This file contains your API key.
// DO NOT commit this file to version control!
// 
// To use this app:
// 1. Get your Gemini API key from https://makersuite.google.com/app/apikey
// 2. Replace 'YOUR_API_KEY_HERE' with your actual key
// 3. Restart the app

class ApiConfig {
  // Replace with your Gemini API key
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
  
  // Check if API key is configured
  static bool get isConfigured => 
      geminiApiKey != 'YOUR_API_KEY_HERE' && 
      geminiApiKey.isNotEmpty;
}
