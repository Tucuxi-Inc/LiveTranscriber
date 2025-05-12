import AVFoundation
import Foundation

public class LiveRecorder: NSObject {
    private let audioEngine = AVAudioEngine()
    private var file: AVAudioFile?
    private var segmentIndex = 0
    private var timer: Timer?

    private var transcriptManager: TranscriptManager
    private let sampleRate: Double = 16000
    private let chunkDuration: TimeInterval = 30
    private let directory: URL

    public init(transcriptManager: TranscriptManager) {
        self.transcriptManager = transcriptManager
        self.directory = FileManager.default.temporaryDirectory.appendingPathComponent("Chunks", isDirectory: true)
        super.init()
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    public func startRecording() throws {
        let inputNode = audioEngine.inputNode
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            try? self?.file?.write(from: buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        startNewSegment()
    }

    public func stopRecording() {
        timer?.invalidate()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        file = nil
    }

    private func startNewSegment() {
        file = nil
        let segmentURL = directory.appendingPathComponent("segment_\(segmentIndex).wav")
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!

        do {
            file = try AVAudioFile(forWriting: segmentURL, settings: format.settings)
        } catch {
            print("Error creating file: \(error)")
        }

        timer = Timer.scheduledTimer(withTimeInterval: chunkDuration, repeats: false) { [weak self] _ in
            self?.transcribeSegment(at: segmentURL)
            self?.segmentIndex += 1
            self?.startNewSegment()
        }
    }

    private func transcribeSegment(at url: URL) {
        let index = segmentIndex
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["whisper", url.path, "--model", "base.en", "--output_format", "txt"]

        task.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.transcriptManager.appendTranscript(for: index, from: url)
            }
        }

        task.launch()
    }
}
