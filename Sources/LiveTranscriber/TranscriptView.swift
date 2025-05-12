import SwiftUI

public struct TranscriptView: View {
    @ObservedObject public var manager: TranscriptManager

    public init(manager: TranscriptManager) {
        self.manager = manager
    }

    public var body: some View {
        ScrollView {
            Text(manager.fullTranscript)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#if DEBUG
#Preview {
    let manager = TranscriptManager()
    manager.appendMockData()
    return TranscriptView(manager: manager)
}
#endif
