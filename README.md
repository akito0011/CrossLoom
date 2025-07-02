# 🧶 CrossLoom

[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)](https://developer.apple.com/swift/)
[![iOS](https://img.shields.io/badge/iOS-17-blue?logo=apple)]
[![OAuth](https://img.shields.io/badge/Auth-Steam%20OAuth2-lightgrey)](https://steamcommunity.com/dev)
[![Backend](https://img.shields.io/badge/Backend-Serverless%20on%20Vercel-black?logo=vercel)]
[![Machine Learning](https://img.shields.io/badge/ML-CreateML%20Recommender-blueviolet)]

**CrossLoom** is a multi-platform game library and recommendation app developed as part of the **Apple Foundation Program @ UniPa (June–July 2025)**.  
The app allows users to authenticate with gaming services (currently **Steam**) and access their game libraries in real time, while receiving personalized game recommendations based on their play and rating history.

---

## 🚀 Features

- 🔐 **Verified OAuth2 Authentication** via Steam  
- 🎮 **Real-time game library access** using official Steam Web API  
- 📈 **Personalized game suggestions** using a trained ML recommendation model  
- ☁️ **Serverless backend** deployed on Vercel for secure REST API interactions  
- 📱 Native iOS interface with SwiftUI  
- 📊 Precision at K metrics up to 100% on top-3 predictions

---

## 📦 Tech Stack

### iOS App
- **Language**: Swift  
- **Framework**: SwiftUI  
- **Architecture**: MVVM  
- **Networking**: URLSession + custom REST calls  
- **ML Integration**: CoreML / CreateML model  

### Backend
- **Platform**: Vercel (Serverless)  
- **Language**: JavaScript / Node.js  
- **Auth**: Steam OAuth2 flow  
- **Endpoints**: REST API for fetching user libraries and profile via SteamID  

---

## 🔐 Authentication Flow

1. The user logs in via Steam OAuth (handled through a Vercel-hosted serverless backend):  
   👉 [View deployment on Vercel](https://vercel.com/akito0011s-projects/cross-loom)

2. Once authenticated, their **public SteamID** is retrieved.

3. The app uses that ID to make direct calls to the **Steam Web API** and fetch:
   - Owned games
   - Playtime stats
   - Game metadata

---

## 🎯 ML Recommendation System

We developed a recommendation model using **CreateML** with **Collaborative Filtering** on real Steam user data.  
The dataset was split 80/20 (train/test) and trained across **307 game classes**.  
It recommends games based on a user’s past ratings (1–5) and generates `K` suggestions.

📊 **Model Precision at K**:

| K | Precision |
|---|-----------|
| 1 | 100%      |
| 2 | 100%      |
| 3 | 100%      |
| 4 | 92%       |
| 5 | 87%       |

> Dataset source: [steam-recommendation-system](https://github.com/your-link) on GitHub

🧠 **Model built and tested in Swift with CreateML, then exported as a CoreML model for local prediction.**

---

## 🧪 Screenshots & Mockups

You can place mockups and screenshots in the `assets/` folder and embed them here:

📺 [Watch the demo on YouTube](https://youtube.com/your-demo-link)


```markdown
### 🔍 Example Screens

<img src="assets/mockup1.png" width="300">
<img src="assets/mockup2.png" width="300">
