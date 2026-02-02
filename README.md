# myFace

## A minimal, open-source Garmin Connect IQ watch face focused on clarity, performance, and battery efficiency.

Note: This project is primarily made for my own use and testing. It may work on other devices, but functionality is not guaranteed. Feel free to clone and test it yourself if you know what you’re doing.

### Features

Clean digital time display

12-hour and 24-hour time formats

Configurable foreground and background colors

Optimized for low power usage

Simple, readable layout suitable for daily use

### Supported Devices

Tested:

Garmin Fenix 6X Pro Solar

Expected to work on:

Fenix 6 / 6 Pro / 6 Sapphire

Other Connect IQ 4.0+ devices (not guaranteed)

### Configuration

The watch face supports user-configurable settings via Garmin Connect:

Foreground color

Background color

12h or 24h time format (device dependent)

## Development
### Requirements

Garmin Connect IQ SDK 8.4.0 or newer

Visual Studio Code with Connect IQ extension (recommended)

Build & Run

Open the project in VS Code

Select a supported device (e.g. Fenix 6X Pro)

Build and run using the Connect IQ tools or simulator

## Project Structure
```
myFace/
├─ source/        # Monkey C source files
├─ resources/     # Layouts, drawables, strings
├─ manifest.xml
├─ monkey.jungle
└─ README.md
```
## Contributing

Pull requests are welcome.

If you plan to add features or device support:

Keep power usage minimal

Avoid unnecessary redraws

Test on real hardware where possible

## License

This project is licensed under the MIT License.
You are free to use, modify, and distribute this software, provided the original copyright notice is retained.

# Disclaimer

This project is not affiliated with or endorsed by Garmin Ltd.
Garmin, Fenix, and Connect IQ are trademarks of Garmin Ltd. or its subsidiaries.
