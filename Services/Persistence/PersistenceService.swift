import Foundation

struct JournalEntry {
    let id: UUID
    let entryDate: String
    var mood: MoodOption?
    var entryText: String
    var affirmations: [String]
    let createdAt: Date
    var updatedAt: Date

    static func empty(for date: Date = Date()) -> JournalEntry {
        let now = Date()
        return JournalEntry(
            id: UUID(),
            entryDate: Self.dateFormatter.string(from: date),
            mood: nil,
            entryText: "",
            affirmations: ["", "", ""],
            createdAt: now,
            updatedAt: now
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

final class PersistenceService {
    private(set) var dailyEntry: JournalEntry

    init(dailyEntry: JournalEntry = .empty()) {
        self.dailyEntry = dailyEntry
    }

    var statusDescription: String {
        "Saved entry for \(dailyEntry.entryDate)."
    }

    func updateDailyEntry(text: String? = nil, mood: MoodOption? = nil, affirmations: [String]? = nil) {
        if let text {
            dailyEntry.entryText = text
        }

        if let mood {
            dailyEntry.mood = mood
        }

        if let affirmations {
            dailyEntry.affirmations = affirmations
        }

        dailyEntry.updatedAt = Date()
    }
}
