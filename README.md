<h1 align="center">🐕 Zoomies</h1>

<p align="center">
  <b>A retro 2D endless runner built with SpriteKit + Swift 🕹️</b><br>
  Run, jump, collect bones, and survive as long as you can!
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?logo=swift&logoColor=white" alt="Swift"/>
  <img src="https://img.shields.io/badge/Xcode-16-blue?logo=xcode&logoColor=white" alt="Xcode"/>
  <img src="https://img.shields.io/badge/Engine-SpriteKit-green?logo=apple&logoColor=white" alt="SpriteKit"/>
  <img src="https://img.shields.io/badge/Platform-iOS-lightgrey?logo=apple&logoColor=white" alt="iOS"/>
</p>

---

## 🧠 Overview

**Zoomies** is a fast-paced 2D pixel-art endless runner starring a loyal German Shepherd 🐶.  
Tap to jump, collect bones to restore health, and dodge logs to keep running!  
The game combines **retro pixel art**, **parallax backgrounds**, and **smooth SpriteKit animation** for an old-school arcade vibe.

---

## 🎮 Gameplay Demo

### 🌅 Intro Scene  
<p align="center">
  <b>Our hero gets ready for a new adventure!</b><br><br>
  <img src="./Zoomies/zoomies-intro.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Intro"/>
</p>

✨ **Highlights**
- Animated barking dog sprite introduces the game
- Smooth fade-in title animation with custom font
- Tap-to-start screen for an interactive opening

---

### 🏃‍♂️ Gameplay  
<p align="center">
  <b>Dodge logs, collect bones, and keep running to survive!</b><br><br>
  <img src="./Zoomies/zoomies-gameplay.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Gameplay"/>
</p>

✨ **Gameplay Features**
- **Dynamic obstacles** (logs) and **collectibles** (bones)  
- Bones restore hearts if health < 5 ❤️  
- **Blinking hearts** for visual feedback and game feel  
- **Real-time distance tracker** in the bottom-right  
- **Smooth jump animation** and parallax-scrolling background

---

### 🎛️ Menu System  
<p align="center">
  <b>Pause, check the rules, or view the credits anytime.</b><br><br>
  <img src="./Zoomies/zoomies-menu.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Menu"/>
</p>

✨ **Menu Features**
- In-game **pause menu** with Resume, Rules, Credits, and Exit  
- Interactive **button states** (clicked/un-clicked versions)  
- **Rules and Credits pages** with their own animations  
- Menu button always visible — tap to pause anytime  

---

### 💀 Game Over  
<p align="center">
  <b>Every run must end — but you can always play again!</b><br><br>
  <img src="./Zoomies/zoomies-gameover.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Game Over"/>
</p>

✨ **Game Over Features**
- Smooth **fade-to-black** transition  
- “Game Over” and “Play Again” titles fade in sequentially  
- **Yes / No** restart options with proper input detection  
- **Skull icon** replaces hearts when health reaches zero 💀  

---

## 🧰 Tech Stack

| Layer | Technology |
|:------|:------------|
| Engine | SpriteKit |
| Language | Swift |
| IDE | Xcode |
| Art | Custom Pixel Sprites (created using [Pixilart](https://www.pixilart.com)) |
| Font | Press Start 2P |
| Platform | iOS |

---

## 👩‍💻 Credits

**Zoomies** by [Ritika Joshi](https://github.com/RJoshi141)  
Game Design, Art & Code by Ritika  
Built with SpriteKit + Swift ✨  
© 2025 Zoomies Studio  

> 🎨 *All pixel art assets are creations by Ritika Joshi and are **not for commercial reuse or redistribution.***  

---

## ⚙️ Setup (for Developers)

Follow these steps to open, build, and run **Zoomies** locally:

### 1️⃣ Clone the repository
```bash
git clone https://github.com/RJoshi141/Zoomies.git
cd Zoomies
````

### 2️⃣ Open in Xcode

* Open **Zoomies.xcodeproj** in Xcode
* Ensure you’re running **Xcode 15 or newer** (Swift 5.9+)
* Set the active scheme to **Zoomies** and your simulator to any iPhone device

### 3️⃣ Run the Game

* Press **⌘ + R** (or Product → Run)
* The game launches in the iOS Simulator
* Tap anywhere to start running 🏃‍♀️

### 4️⃣ Optional: Customize Assets

* Modify textures or UI art in the **Assets.xcassets** folder
* Keep pixel scaling consistent and use `.nearest` filtering for crisp visuals
* To add new sprites, import your **.png** files and reference them in the `GameScene.swift`

---

## ⚖️ License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.
© 2025 Ritika Joshi

> 🧩 Code is open-source and free for educational use.
> 🎨 Pixel art and design assets are protected and **not for commercial distribution.**
