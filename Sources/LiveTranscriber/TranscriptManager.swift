import Foundation
import Combine

public class TranscriptManager: ObservableObject {
    public struct TranscriptSegment: Identifiable {
        public let id = UUID()
        public let index: Int
        public let text: String
    }

    @Published public private(set) var transcriptSegments: [TranscriptSegment] = []

    public var fullTranscript: String {
        transcriptSegments
            .sorted(by: { $0.index < $1.index })
            .map { $0.text }
            .joined(separator: " ")
    }

    public init() {}

    public func appendTranscript(for index: Int, from url: URL) {
        let transcriptURL = url.deletingPathExtension().appendingPathExtension("txt")
        guard FileManager.default.fileExists(atPath: transcriptURL.path) else { return }

        do {
            let text = try String(contentsOf: transcriptURL, encoding: .utf8)
            let segment = TranscriptSegment(index: index, text: text.trimmingCharacters(in: .whitespacesAndNewlines))
            DispatchQueue.main.async {
                self.transcriptSegments.append(segment)
            }
        } catch {
            print("Failed to read transcript for segment \(index): \(error)")
        }
    }

    public func clear() {
        transcriptSegments.removeAll()
    }
}

public extension TranscriptManager {
    func appendMockData() {
        transcriptSegments = [
            TranscriptSegment(index: 0, text: "Welcome. Today we explored early childhood experiences."),
            TranscriptSegment(index: 1, text: "Client discussed work-related anxiety and coping strategies."),
            TranscriptSegment(index: 2, text: "Next session will focus on schema development.")
        ]
    }
}
