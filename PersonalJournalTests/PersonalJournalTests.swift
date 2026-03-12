import XCTest
@testable import PersonalJournal

final class PersonalJournalTests: XCTestCase {
    func testAISummaryReturnsPlaceholder() {
        let service = AIService()
        let summary = service.summarize("This is a sample journal entry.")

        XCTAssertTrue(summary.hasPrefix("Summary placeholder:"))
    }

    func testPersistenceStatusDescription() {
        let persistence = PersistenceService()
        XCTAssertEqual(persistence.statusDescription, "Persistence service configured (stub).")
    }
}
