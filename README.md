# LiveTranscriber

**LiveTranscriber** is a macOS Swift Package designed to support on-device, privacy-first, real-time transcription of spoken sessions or conversations. It is ideal for applications in healthcare, legal, educational, or any domain where offline, secure note generation is a priority.

Built around Apple's `AVAudioEngine`, this package records microphone input in 30-second `.wav` segments, then invokes a local Whisper-based transcription engine (e.g., `whisper.cpp` or `openai-whisper`) to convert speech to text. A `TranscriptManager` collects and organizes the segments, and a SwiftUI `TranscriptView` provides live display.

---

## 🚀 Features

- 🔐 **Fully Local**: No audio leaves the device. Compatible with local Whisper implementations.
- 🎙 **Live Audio Capture**: Uses `AVAudioEngine` to capture and buffer audio in real-time.
- ✂️ **Segmented Recording**: Records audio in 30-second chunks for efficient transcription.
- 🧠 **Transcript Aggregation**: Appends results sequentially for unified session notes.
- 🖥 **SwiftUI-Compatible**: Includes a view for easy display of real-time transcripts.
- 🧪 **Mock Support**: Add mock data for preview/testing in development.

---

## 🧰 Components

| File | Description |
|------|-------------|
| `LiveRecorder.swift` | Manages audio engine setup, file writing, and segment timing. |
| `TranscriptManager.swift` | Aggregates transcriptions, supports live updates and previews. |
| `TranscriptView.swift` | Displays the aggregated transcript in a scrolling SwiftUI view. |

---

## 🛠 Requirements

- macOS 13 or later
- Swift 5.9+
- A Whisper-compatible CLI (`whisper`, `whisper.cpp`, or similar) installed and accessible via `/usr/bin/env whisper`
- Minimum permissions for microphone access in app entitlements

---

## 🧩 Installation

### 1. Add the Swift Package

In Xcode:
- Go to **File > Add Packages...**
- If using Git: Paste your GitHub repo URL
- If using locally: Use **Add Local Package...** and select the folder

---

## ✅ Usage Example

### 1. Import and Initialize

```swift
import LiveTranscriber

let transcriptManager = TranscriptManager()
let recorder = LiveRecorder(transcriptManager: transcriptManager)
```

### 2. Start Recording

```swift
try? recorder.startRecording()
```

### 3. Stop Recording

```swift
recorder.stopRecording()
```

### 4. Show the Transcript in SwiftUI

```swift
TranscriptView(manager: transcriptManager)
```

---

## 🧪 SwiftUI Preview Example

```swift
#Preview {
    let manager = TranscriptManager()
    manager.appendMockData()
    return TranscriptView(manager: manager)
}
```

---

## 📂 File Output

- `.wav` files are saved to the temporary directory under `Chunks/`
- Transcription output is expected to be written by the Whisper CLI as `.txt` files with the same basename

---

## 🔄 Transcription Flow

1. Audio is tapped and buffered from the default input device.
2. Every 30 seconds, a `.wav` segment is written and a new file is started.
3. Whisper CLI is called on the segment using `Process`.
4. The `.txt` file returned is appended to the overall transcript.

---

## 📌 Notes

- For long-form sessions (e.g., therapy or interviews), this chunked design ensures Whisper-compatible performance even on limited hardware.
- `LiveRecorder` handles segment lifecycle; you can adjust `chunkDuration` if needed.
- Use a custom Whisper CLI path or flags by modifying the `Process` launch in `transcribeSegment`.

---

## 🧷 Permissions

Make sure your app includes the necessary permissions in its `.entitlements` and `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app requires microphone access to transcribe speech in real time.</string>
```

---

## 🪪 License

MIT

---

## 🧠 Designed For

Projects where:
- Transcription must be local
- Connectivity is unreliable or disallowed
- Session summaries, note generation, or searchable transcripts are core features

---

## 🙋 Support

Feel free to open issues or pull requests if you extend the package to:
- Support other file formats
- Add timestamped transcript exports
- Integrate live speaker identification
