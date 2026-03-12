import XCTest
@testable import PersonalJournal

final class PersonalJournalTests: XCTestCase {
    func testAISummaryReturnsPlaceholder() {
        let service = AIService()
        let summary = service.summarize("This is a sample journal entry.")

        XCTAssertTrue(summary.hasPrefix("Summary placeholder:"))
    }

    func testFallbackAffirmationsForMoodReturnsThreeLines() {
        let service = AIService(provider: nil)

        let suggestions = service.suggestAffirmations(for: .lowEnergy, context: nil)

        XCTAssertEqual(suggestions.count, 3)
        XCTAssertTrue(suggestions.allSatisfy { !$0.isEmpty })
    }

    func testPersistenceUpdatesSelectedAffirmations() {
        let persistence = PersistenceService()
        let affirmations = [
            "I welcome this day.",
            "I trust my pace.",
            "I can begin again."
        ]

        persistence.updateDailyEntry(
            text: "Feeling okay.",
            mood: .hopefulCurious,
            affirmations: affirmations
        )

        XCTAssertEqual(persistence.dailyEntry.mood, .hopefulCurious)
        XCTAssertEqual(persistence.dailyEntry.affirmations, affirmations)
        XCTAssertEqual(persistence.dailyEntry.entryText, "Feeling okay.")
    }
}
