Sorry for the misspelling of coords :-) 
# Cord Copier

Cord Copier is a standalone in-game developer tool for FiveM
that allows you to read, visualize, and copy coordinates directly in-game

Built for mapping, targets, and all types of server development.


---

##  Features

- Clear circular target marker ("orb") using raycasting
- Stable hit detection on props, walls, benches, chairs, and more
* Copy coordinates in multiple formats
* Toggle via command or keybind  (change in client.lua at bottom)


---

##  Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)

---

## Installation

1. Place the script in:
   resources/cord_copier


2. Add to your `server.cfg`:
   
   ensure cord_copier


3. Start your server or run:
   
   ensure cord_copier


**Done!**
## How to use

### Open/Close
- Command: /cord

- Keybind: F6 (standard) Change in your keymappings.


---

## 🧭 Basic Functionality

* The target marker follows a camera raycast
* Works on props, objects, walls, and terrain
* Right-click (**RMB**) opens the menu
* Coordinates update in real time

---

## 📋 copy Coordinate Formats

You can copy coordinates directly to your clipboard in the following formats:

### • Formats
```lua
vec3(x, y, z)

• vec4

vec4(x, y, z, h)

• table

{ x = x, y = y, z = z, h = h }

• json

{ "x": x, "y": y, "z": z, "h": h }

• raw without ( and vec text.

x, y, z, h

All formats are copied fully formatted and ready to use.

