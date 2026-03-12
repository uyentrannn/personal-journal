# Personal Journal

Uyen's personal journal app, designed to feel like opening a physical notebook while staying private, offline-capable, and AI-assisted.

## Product direction

This project will be built as **iOS app + web app with a shared backend/data model**.

### Phase strategy

1. **Primary (Phase 1): iOS-first app**
   - Build the core daily ritual flow first on iPhone.
   - Prioritize tactile interactions, visual warmth, and low-friction writing.
2. **Secondary (Phase 2): web companion**
   - Add a web app for desktop journaling, review, and search.
   - Reuse the same entry schema, mantra library, and AI behavior.

## Why this approach fits the PRD

- Preserves the immersive notebook experience on iOS first.
- Enables cross-device access later without rewriting core logic.
- Keeps data model and backend behavior consistent across platforms.
- Supports private, local-first workflows with optional sync.

## Proposed architecture

### Clients

- **iOS app (SwiftUI)**
  - Core writing flow, mood check-in, mantra card, gratitude section.
  - Local encrypted storage and offline-first behavior.
- **Web app (Next.js/React)**
  - Matching journal layout and typography for consistency.
  - Strong archive/search/review experience on larger screens.
  - PWA capabilities for offline entry drafts.

### Shared backend & data model

- **API layer**
  - Journal entries CRUD
  - Mantra retrieval by day-of-year
  - Optional AI endpoints (affirmations + reflection prompt)
- **Shared domain model**
  - `JournalEntry`
  - `MoodCheckIn`
  - `AffirmationSet`
  - `DailyMantra`
  - `GratitudeItem`
  - `FavoriteMantra`
- **Storage**
  - Local-first on each client
  - Cloud sync for backup and multi-device continuity

## Canonical data model (v1)

```ts
JournalEntry {
  id: string
  entryDate: string // YYYY-MM-DD
  displayHeader: string // "Monday 24th January 2026 ♡"
  dayOfYear: number
  mood?: "calm_centered" | "anxious_overwhelmed" | "low_energy" |
         "hopeful_curious" | "grieving_processing" |
         "excited_expansive" | "going_through_motions"
  affirmations: [string, string, string]
  mantra: {
    id: string
    text: string
    source: string
    reflection?: string
  }
  gratitude: [string, string, string]
  createdAt: string
  updatedAt: string
}
```

## Privacy and offline principles

- No social features.
- No public sharing.
- No analytics/telemetry in v1.
- Entries encrypted at rest.
- App remains usable offline:
  - Daily template always available
  - Bundled mantra library available
  - Cached affirmation suggestions used when AI is unavailable

## Delivery roadmap

### Milestone 1 — iOS foundation

- Create journal opening animation and daily page template.
- Implement local persistence and date/day-of-year handling.
- Add mood check-in and AI suggestion interface with offline fallback.

### Milestone 2 — archive and continuity

- Calendar navigation, full-text search, streaks, favorites.
- Monthly summary generation.

### Milestone 3 — web companion

- Build web journal page and archive using shared schema.
- Connect to shared backend endpoints.
- Ensure parity for core entry structure and content behavior.

## Definition of success

The app succeeds if it supports a consistent daily practice across iOS and web while preserving the intimate, private, notebook-like experience.
