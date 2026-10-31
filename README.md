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

