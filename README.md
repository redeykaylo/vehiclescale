Sure! Here’s a clean, clear README.md for your GitHub project in English:

# Vehicle Scale Script for FiveM

This script adds functional vehicle weighing stations to your FiveM server. Players can drive onto a scale, press a key to weigh their vehicle including the cargo inside the trunk, and get notified of the total weight. The data is also logged to a Discord channel via webhook.

---

## Features

- Blips marking scale locations on the map  
- 3D text prompt to interact with the scale  
- Calculates vehicle weight plus inventory (trunk) weight  
- Sends vehicle weight logs to Discord webhook  
- Uses `ox_inventory` export to get trunk items and their weights  
- Scales are spawned as props at configured locations  

---

## Installation

1. Clone or download this repository into your FiveM resources folder.

2. Add the resource to your `server.cfg`:
    ```
    ensure vehicle_scale
    ```

3. Configure scale locations and Discord webhook in `config.lua`.

4. Make sure `ox_inventory` is installed and running on your server, as this script depends on it for inventory management.

---

## Usage

- Drive a vehicle onto the scale location.
- When near the scale, press **E** (default) to weigh your vehicle.
- A notification will show the vehicle’s base weight, cargo weight, and total weight.
- The weight data is logged to Discord through the configured webhook.

---

## Configuration

Edit `config.lua` to:

- Set scale locations and headings
- Change interaction distance
- Update Discord webhook URL

Example:
```lua
Config.ScaleZones = {
    {
        coords = vector3(1519.3138, 781.7233, 77.4407),
        heading = 180.0,
        text = "Press ~g~[E]~s~ to weigh your vehicle"
    }
}

Config.InteractDist = 5.0
Config.Webhook = 'YOUR_DISCORD_WEBHOOK_URL'

---

## Dependencies

* [ox\_inventory](https://github.com/overextended/ox_inventory) - For accessing vehicle trunk inventory

---

## License

MIT License — feel free to use, modify, and distribute.

---

## Support

If you encounter any issues or have questions, feel free to open an issue on GitHub.

---

## Credits

Created by Tobias (Redey)
Inspired by community scripts and FiveM resources.

```

If you want, I can help you generate badges, example screenshots, or additional sections!
```
