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


---

### 🏃‍♂️ Gameplay  
<p align="center">
  <b>Dodge logs, collect bones, and keep running to survive!</b><br><br>
  <img src="./Zoomies/zoomies-gameplay.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Gameplay"/>
</p>


- **Dynamic obstacles** (logs) and **collectibles** (bones)  
- Bones restore hearts if health < 5 ❤️  
- **Real-time distance tracker** in the bottom-right  
- **Smooth jump animation** and parallax-scrolling background

---

### 🎛️ Menu System  
<p align="center">
  <b>Pause, check the rules, or view the credits anytime.</b><br><br>
  <img src="./Zoomies/zoomies-menu.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Menu"/>
</p>


- In-game **pause menu** with Resume, Rules, Credits, and Exit  
- **Rules and Credits pages** with their own animations  

---

### 💀 Game Over  
<p align="center">
  <b>Every run must end — but you can always play again!</b><br><br>
  <img src="./Zoomies/zoomies-gameover.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Game Over"/>
</p>

- **Yes / No** restart options with proper input detection  

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
<details>
<summary><b>🎨 Full Asset Reference (click to expand)</b></summary>
<br>

# 🧾 Zoomies – Sprite & Asset Reference Sheet  

All artwork was created by **Ritika Joshi** using [Pixilart](https://www.pixilart.com)  
and is **not licensed for commercial reuse or redistribution**.  
All assets are stored in **`Assets.xcassets`**, organized by folders.

---

## 🐕 Character Sprites  

| Sprite | Description | Frames | Used In |
|:------:|:-------------|:-------:|:--------|
| <img src="./Zoomies/Zoomies/Assets/dog-idle-sprite.png" width="100"/> | Dog sitting + wagging tail (idle) | 16 | Title screen |
| <img src="./Zoomies/dog-running-sprite.png" width="100"/> | Running animation | 8 | Gameplay |
| <img src="./Zoomies/dog-jump-sprite.png" width="100"/> | Jump animation | 7 | Gameplay |
| <img src="./Zoomies/dog-hurt-sprite.png" width="100"/> | Hurt animation (flinch) | 4 | When hit |
| <img src="./Zoomies/dog-die-sprite.png" width="100"/> | Death animation | 8 | When HP = 0 |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-bark-sprite.imageset/dog-bark-sprite.png" width="100"/> | Barking dog | 13 | Title screen |
| <img src="./Zoomies/dog-sit-sprite.png" width="100"/> | Sitting dog | 9 | Credits screen |

---

## 🪵 Obstacles & Collectibles  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/wooden-log.png" width="100"/> | Wooden log obstacle | Gameplay |
| <img src="./Zoomies/dog-bone.png" width="100"/> | Collectible bone | Gameplay |
| <img src="./Zoomies/dog-bone-yellow.png" width="100"/> | Blinking yellow bone effect | Bone collection |
| <img src="./Zoomies/health-skull.png" width="80"/> | Skull shown on death | Health bar on death |

---

## ❤️ UI Elements  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/heart.png" width="60"/> | Player health unit | Health bar |
| <img src="./Zoomies/health_label.png" width="180"/> | “HEALTH” label | Bottom-left |
| <img src="./Zoomies/distance_label.png" width="180"/> | “DISTANCE” label | Bottom-right |

---

## 🖥️ Menu & Buttons  

| Button | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/menu-button.png" width="100"/> | Menu button (pause) | Gameplay |
| <img src="./Zoomies/menu-button-clicked.png" width="100"/> | Menu button (pressed) | Gameplay |
| <img src="./Zoomies/resume-button.png" width="140"/> | Resume game | Menu |
| <img src="./Zoomies/rules-button.png" width="140"/> | Rules page | Menu |
| <img src="./Zoomies/credits-button.png" width="140"/> | Credits page | Menu |
| <img src="./Zoomies/exit-button.png" width="140"/> | Exit to title | Menu |
| <img src="./Zoomies/back-button.png" width="100"/> | Back navigation | Rules/Credits |

---

## 🪩 Titles & Overlays  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/zoomies-title.png" width="200"/> | Main title | Title screen |
| <img src="./Zoomies/tap-to-start-title.png" width="200"/> | “Tap to Start” label | Idle state |
| <img src="./Zoomies/game-over-title.png" width="200"/> | Game Over text | End screen |
| <img src="./Zoomies/play-again-title.png" width="200"/> | “Play Again?” text | End screen |
| <img src="./Zoomies/menu-rules.png" width="200"/> | Rules panel | Rules scene |
| <img src="./Zoomies/menu-credits.png" width="200"/> | Credits panel | Credits scene |

---

## ☁️ Environment  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/cloud1.png" width="120"/> | Small cloud | Background |
| <img src="./Zoomies/cloud2.png" width="120"/> | Medium cloud | Background |
| <img src="./Zoomies/cloud3.png" width="120"/> | Large cloud | Background |

---

## 🪄 Miscellaneous  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="./Zoomies/skull.png" width="60"/> | Decorative skull above Game Over | Game over |
| <img src="./Zoomies/PressStart2P-Regular.otf" width="150"/> | Retro pixel font | UI text |

---

</details>

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
