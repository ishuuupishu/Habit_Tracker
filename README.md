# 🏃 Habit Tracker App

A comprehensive **Flutter application** to help users create, track, and manage daily habits while staying motivated with inspirational quotes. This app leverages **Firebase** for real-time data synchronization and persistent storage, ensuring your progress is always backed up and accessible across devices.

---

## 📌 Features

### 1. **User Registration & Authentication**
- **Firebase Authentication** (Email & Password)  
- Registration Form Includes:  
  - Display Name (Required)  
  - Email (Required)  
  - Password (Required, min. 8 chars with uppercase, lowercase, numbers)  
  - Gender (Optional: Male / Female / Other)  
  - Other Details (Optional: DOB, Height, etc.)  
  - Terms & Conditions Checkbox (Required)  
- Validation & Error Handling  
- Remember User Session via Shared Preferences for faster login  
- Successful registration & login sync user data in Firestore:  
  `users/{userId}`

---

### 2. **User Profile Viewing & Editing**
- View profile information: Display Name, Email, Gender, Other Details  
- Editable Fields: Name, Gender, Other Details (Email is read-only)  
- Updates validated & synced to Firestore instantly  
- Local cache ensures immediate UI reflection  
- Success/Error messages on updates  

---

### 3. **Habit Creation & Management**
- Create, edit, delete habits with:  
  - **Title** (Required)  
  - **Category** (Required: Health, Study, Fitness, Productivity, etc.)  
  - **Frequency** (Required: Daily/Weekly)  
  - **Start Date** (Optional)  
  - **Notes/Description** (Optional)  
- Habit data structure in Firestore:  
  `users/{userId}/habits/{habitId}`  
  - Title, Category, Frequency, Creation Date  
  - Current Streak Count, Completion History, Notes  

---

### 4. **Habit Completion Tracking**
- Mark habits as completed for today/week  
- Instant sync with Firestore  
- Valid completion only for the current day/week  
- Track progress and reset streak if missed  

---

### 5. **Streak & Progress Visualization**
- Track consecutive completion streaks  
- Dynamic streak calculation based on Firestore history  
- Display streak count on habit cards & details screen  
- View habit completion trends using charts (bar/line/custom)  

---

### 6. **Categories & Filtering**
- Predefined Categories: Health, Study, Fitness, Productivity, Mental Health, Others  
- Category tags with icons for better UX  
- Filter habits by category in the list view  

---

### 7. **Theme & User Preferences**
- Light Mode / Dark Mode toggle  
- Store preference locally & sync with Firestore  
- Apply theme instantly without app restart  

---

### 8. **Motivational Quotes**
- Fetch quotes from free public APIs (Quotable, ZenQuotes, etc.)  
- Scrollable list or carousel on the home screen  
- Features per quote:  
  - Copy to clipboard  
  - Favorite/unfavorite quotes saved to Firestore:  
    `users/{userId}/favorites/quotes/{quoteId}`  
  - Randomized display on refresh or app launch  

---

### 9. **Favorites Quotes Screen**
- Display only user’s saved quotes  
- Update Firebase & UI instantly on unfavoriting  

---

## 📸 Screenshots


 <img width="180" height="580" alt="Screenshot (194)" src="https://github.com/user-attachments/assets/24975185-f69e-4f32-868a-4321ac27b14a" /> <img width="180" height="480" alt="Screenshot (232)" src="https://github.com/user-attachments/assets/cde3abde-0bfb-40f0-a728-3d249f4b549b" /> <img width="180" height="580" alt="Screenshot (192)" src="https://github.com/user-attachments/assets/64409aa5-65af-4be4-9c3f-2cac7f1cc393" /> <img width="180" height="580" alt="Screenshot (198)" src="https://github.com/user-attachments/assets/513b70ec-ab49-422b-8cb9-fb5dbe808be8" /> <img width="180" height="580" alt="Screenshot (199)" src="https://github.com/user-attachments/assets/eb9b0975-8990-4683-badc-582501ea5a19" /> <img width="180" height="580" alt="Screenshot (220)" src="https://github.com/user-attachments/assets/51087037-d785-4ebc-9a19-491a5d790949" /> <img width="180" height="580" alt="Screenshot (205)" src="https://github.com/user-attachments/assets/3f4779e3-b168-4b5f-99eb-ee0c79a9cbb6" /> <img width="180" height="580" alt="Screenshot (206)" src="https://github.com/user-attachments/assets/040fca2d-2deb-44f3-b196-82f8ad02cd4f" /> <img width="180" height="580" alt="Screenshot (209)" src="https://github.com/user-attachments/assets/b8444cfa-75cd-4f90-868c-40ce879efa88" /> <img width="180" height="580" alt="Screenshot (208)" src="https://github.com/user-attachments/assets/721ae4ec-02c8-4eee-b7bb-24a334a18f17" /> <img width="180" height="580" alt="Screenshot (207)" src="https://github.com/user-attachments/assets/5690cd2e-0f27-4d12-b79c-7ea020dd00a3" /> <img width="180" height="580" alt="Screenshot (210)" src="https://github.com/user-attachments/assets/434b9e64-6161-44ed-a112-e006a55411b9" /> <img width="180" height="580" alt="Screenshot (211)" src="https://github.com/user-attachments/assets/b1c237fb-bbd3-404d-b7af-aa905996609d" /> <img width="180" height="580" alt="Screenshot (212)" src="https://github.com/user-attachments/assets/5a2e4da0-bf8f-4d14-b923-6abe6ded873a" /> <img width="180" height="580" alt="Screenshot (213)" src="https://github.com/user-attachments/assets/e00762df-3ad4-4791-b9ad-3de2f3c3de71" /> <img width="180" height="580" alt="Screenshot (215)" src="https://github.com/user-attachments/assets/92905e3a-e78a-46f5-9d12-63ab868607ae" /> <img width="180" height="580" alt="Screenshot (217)" src="https://github.com/user-attachments/assets/0f788e63-b49a-4db9-b8f4-101dfd86122e" /> <img width="180" height="580" alt="Screenshot (218)" src="https://github.com/user-attachments/assets/e0848d60-af7d-48d6-9e7c-5bde0a985253" /> <img width="180" height="580" alt="Screenshot (214)" src="https://github.com/user-attachments/assets/6a661098-f41a-4581-bad1-9d1b08a6ca49" /> <img width="180" height="580" alt="Screenshot (216)" src="https://github.com/user-attachments/assets/222813f9-1a1d-4640-9c0b-56e8b622626e" /> <img width="180" height="580" alt="Screenshot (221)" src="https://github.com/user-attachments/assets/d5a6db58-267b-4d7b-85a8-6c5f98aa089a" /> <img width="180" height="580" alt="Screenshot (223)" src="https://github.com/user-attachments/assets/d2d3ec34-39b4-48cb-8e01-acd043eb892a" /> <img width="180" height="580" alt="Screenshot (225)" src="https://github.com/user-attachments/assets/81e40dae-a2a3-4c99-9113-1f1117da57ce" /> <img width="180" height="580" alt="Screenshot (228)" src="https://github.com/user-attachments/assets/7c96bf00-4e35-45f5-8d26-1cd3175e7190" /> <img width="180" height="580" alt="Screenshot (227)" src="https://github.com/user-attachments/assets/44213f57-1afa-4071-bc42-5318cc817278" /> <img width="180" height="580" alt="Screenshot (226)" src="https://github.com/user-attachments/assets/47cf6963-28f8-4618-9f5a-8201d06aa09e" />




