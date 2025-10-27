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

## Overview

**Zoomies** is a fast-paced 2D pixel-art endless runner starring a loyal German Shepherd 🐶.  
Tap to jump, collect bones to restore health, and dodge logs to keep running!  
The game combines **retro pixel art**, **parallax backgrounds**, and **smooth SpriteKit animation** for an old-school arcade vibe.

---

## Gameplay Demo

<p align="center">
  <b>Our hero gets ready for a new adventure!</b><br><br>
  <img src="./Zoomies/zoomies-intro.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Intro"/>
</p>

<p align="center">
  <b>Dodge logs, collect bones, and keep running to survive!</b><br><br>
  <img src="./Zoomies/zoomies-gameplay.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Gameplay"/>
</p>

<p align="center">
  <b>Pause, check the rules, or view the credits anytime.</b><br><br>
  <img src="./Zoomies/zoomies-menu.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Menu"/>
</p>

<p align="center">
  <b>Every run must end — but you can always play again!</b><br><br>
  <img src="./Zoomies/zoomies-gameover.gif" width="520" style="border-radius:12px; box-shadow:0 0 10px rgba(0,0,0,0.15);" alt="Zoomies Game Over"/>
</p>

---

## Tech Stack

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
  <summary><h2>Full Asset Reference (click to expand)</h2></summary>


All artwork was created by **Ritika Joshi** using [Pixilart](https://www.pixilart.com)  
and is **not licensed for commercial reuse or redistribution**.  
All assets are stored in **`Assets.xcassets`**, organized by folders.

## Character Sprites  

| Sprite | Description | Frames | Used In |
|:------:|:-------------|:-------:|:--------|
| <img src="Zoomies/Assets.xcassets/Sprites/dog-idle-sprite.imageset/dpg-idle-sprite.png" width="800"/> | Dog sitting + wagging tail (idle) | 16 | Title screen |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-running-sprite.imageset/dog-running-sprite.png" width="400"/> | Running animation | 8 | Gameplay |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-jump-sprite.imageset/dog-jump-sprite2.png" width="400"/> | Jump animation | 7 | Gameplay |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-hurt-sprite.imageset/dog-hurt-sprite2.png" width="200"/> | Hurt animation (flinch) | 4 | When hit |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-die-sprite.imageset/dog-die-sprite.png" width="400"/> | Death animation | 8 | When HP = 0 |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-bark-sprite.imageset/dog-bark-sprite.png" width="800"/> | Barking dog | 13 | Title screen |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-sit-sprite.imageset/dog-sit-sprite.png" width="500"/> | Sitting dog | 9 | Credits screen |


## Obstacles & Collectibles  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="Zoomies/Assets.xcassets/Sprites/wooden-log.imageset/wooden-log.png" width="90"/> | Wooden log obstacle | Gameplay |
| <img src="Zoomies/Assets.xcassets/UI/dog-bone.imageset/dog-bone.png" width="90"/> | Collectible bone | Gameplay |
| <img src="Zoomies/Assets.xcassets/Sprites/dog-bone-collected-sprite.imageset/dog-bone-collected-sprite.png" width="300"/> | Blinking yellow bone effect | Bone collection |


## UI Elements  

| Sprite | Description | Used In |
|:------:|:-------------|:--------|
| <img src="Zoomies/Assets.xcassets/UI/heart.imageset/heart-health.png" width="80"/> | Player health unit | Health bar |
| <img src="Zoomies/Assets.xcassets/Clouds/cloud1.imageset/cloud1.png" width="80"/> | Small cloud | Background |
| <img src="Zoomies/Assets.xcassets/Clouds/cloud2.imageset/cloud2.png" width="80"/> | Medium cloud | Background |
| <img src="Zoomies/Assets.xcassets/Clouds/cloud3.imageset/cloud3.png" width="80"/> | Large cloud | Background |
| <img src="Zoomies/Assets.xcassets/UI/menu-button.imageset/menu-button.png" width="100"/> | Menu button (pause) | Gameplay |
| <img src="Zoomies/Assets.xcassets/UI/resume-button.imageset/resume-button.png" width="100"/> | Resume game | Menu |
| <img src="Zoomies/Assets.xcassets/UI/rules-button.imageset/rules-button.png" width="100"/> | Rules page | Menu |
| <img src="Zoomies/Assets.xcassets/UI/credits-button.imageset/credits-button.png" width="100"/> | Credits page | Menu |
| <img src="Zoomies/Assets.xcassets/UI/exit-button.imageset/exit-button.png" width="100"/> | Exit to title | Menu |
| <img src="Zoomies/Assets.xcassets/UI/back-button.imageset/back-button.png" width="100"/> | Back navigation | Rules/Credits |

</details>

---

## Credits

**Zoomies** by [Ritika Joshi](https://github.com/RJoshi141)  
Game Design, Art & Code by Ritika  
Built with SpriteKit + Swift ✨  
© 2025 Zoomies Studio  

> 🎨 *All pixel art assets are creations by Ritika Joshi and are **not for commercial reuse or redistribution.***  

---

## Setup (for Developers)

Follow these steps to open, build, and run **Zoomies** locally:

### 1. Clone the repository
```bash
git clone https://github.com/RJoshi141/Zoomies.git
cd Zoomies
````

### 2. Open in Xcode

* Open **Zoomies.xcodeproj** in Xcode
* Ensure you’re running **Xcode 15 or newer** (Swift 5.9+)
* Set the active scheme to **Zoomies** and your simulator to any iPhone device

### 3. Run the Game

* Press **⌘ + R** (or Product → Run)
* The game launches in the iOS Simulator
* Tap anywhere to start running 🏃‍♀️

### 4. Optional: Customize Assets

* Modify textures or UI art in the **Assets.xcassets** folder
* Keep pixel scaling consistent and use `.nearest` filtering for crisp visuals
* To add new sprites, import your **.png** files and reference them in the `GameScene.swift`

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.
© 2025 Ritika Joshi
