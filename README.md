# Second Wind

Second Wind is a bachelor's thesis project, that reads physiological data from a chest strap (Polar H10) and uses it to guide your endurance training through audio feedback.

Built at Alpen-Adria-Universität Klagenfurt, 2026.

--

## The Problem

Most running watches and apps already give live heart rate feedback, but they rely on fixed zone thresholds. These ignore how your body is responding today, since fatigue, heat, and individual fitness all shift your real limits.

This project streams heart rate and HRV from the Polar H10 chest strap to your iPhone and adapts its audio feedback to your current state.

---

## What This App Does

The app connects to a Bluetooth chest strap, streams your heart rate and RR intervals, and continuously evaluates your current physiological state. Based on that, it gives you audio feedback through your headphones and tells you to speed up or slow down to stay in your target zone.

The feedback isn't just "go faster". It takes into account where you are in your session, how your HRV is trending, and what kind of training you're doing. Three feedback strategies are implemented and compared in field tests.

- **Static** uses fixed zone thresholds and simple rules.
- **Contextual** reacts to short term HRV changes during the session.
- **Personalized** adapts the thresholds to the individual runner.

---

## Hardware

- **Polar H10** chest strap (or any BLE device implementing the standard Heart Rate Profile)
- iPhone (iOS 16+)
- AirPods or any headphones for audio feedback

---

## Tech Stack

- **Swift / SwiftUI** — UI and app logic
- **Core Bluetooth** — direct BLE communication, no third-party SDK dependencies
- **AVSpeechSynthesizer** — voice feedback delivered through headphones
- **CoreML** — on-device ML inference for training state classification

---

## How It Works

### 1. BLE Connection

The app scans for devices advertising the standard Heart Rate Service (`0x180D`). No proprietary SDK is used. Core Bluetooth communicates directly with any compatible chest strap. When a supported device is found, the app connects automatically.

Supported devices are configured in `Configuration.swift` and matched by name.

```swift
static let supportedDevices: [String] = ["Polar"]
```

### 2. Data Parsing

The chest strap sends raw bytes following the [Bluetooth Heart Rate Profile](https://www.bluetooth.com/specifications/specs/heart-rate-profile-1-0/) specification.

The app parses two things:

- **Heart rate** in beats per minute
- **RR intervals**, the time between individual heartbeats in milliseconds, which are the foundation for HRV analysis

### 3. Training Zone Classification

Before a session the user selects a training zone and enters their age. Max heart rate is estimated as 220 minus age. The app converts this into absolute BPM boundaries for the chosen zone.

Zone boundaries follow the five zone scale reported by Seiler (2010) in the International Journal of Sports Physiology and Performance.

| Zone | Name      | % of Max HR   |
| ---- | --------- | ------------- |
| 1    | Recovery  | 60 to 72%     |
| 2    | Endurance | 72 to 82%     |
| 3    | Aerobic   | 82 to 87%     |
| 4    | Threshold | 87 to 92%     |
| 5    | Maximum   | 92% and above |

### 4. Adaptive Feedback

Every second, the app checks whether you are in your target zone. If you have been outside it long enough, it speaks through your headphones.

- **"Faster"** means your heart rate is too low for the target zone
- **"Slower"** means your heart rate is too high
- **Silence** means you are exactly where you should be

A configurable cooldown (default 10 seconds) prevents the feedback from becoming noise.

