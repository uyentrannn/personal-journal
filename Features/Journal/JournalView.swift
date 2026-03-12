import SwiftUI

struct JournalView: View {
    let aiService: AIService
    let persistenceService: PersistenceService

    @State private var entryText = ""

    var body: some View {
        Form {
            Section("Today's Entry") {
                TextEditor(text: $entryText)
                    .frame(minHeight: 180)

                Button("Summarize with AI") {
                    _ = aiService.summarize(entryText)
                }
                .buttonStyle(.borderedProminent)
            }

            Section("Storage") {
                Text(persistenceService.statusDescription)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Journal")
    }
}
