# AI Usage and Reflection

## Project: RijksNav — Art Institute of Chicago Navigation App

---

## Question 1: How did you use AI tools during this project?

I used Claude (Anthropic) as my primary AI assistant throughout the development of this project. AI helped me in several key areas:

- **Project setup**: Guided me step by step through creating the Xcode project and connecting it to GitHub via Terminal when the Xcode GUI method didn't work.
- **API selection**: Helped me evaluate multiple museum APIs (Rijksmuseum, Harvard Art Museums, Art Institute of Chicago) and troubleshoot why each one did or didn't work for our use case.
- **Code generation**: Generated all Swift files including the data models (`ArtObject.swift`), the ViewModel (`RijksViewModel.swift`), and the SwiftUI views (`ArtListView`, `ArtRowView`, `ArtDetailView`).
- **Debugging**: Helped diagnose a JSON decoding error by analyzing the actual API response structure via `curl` commands in Terminal, and fixed a build error related to `@MainActor` conformance.

---

## Question 2: What did you learn from working with AI on this project?

Working with AI accelerated my understanding of several Swift and iOS concepts:

- **MVVM architecture**: Seeing the ViewModel pattern implemented with `ObservableObject`, `@Published`, and `async/await` helped me understand how SwiftUI views react to data changes.
- **Codable and CodingKeys**: I learned how to map JSON keys with different naming conventions (snake_case vs camelCase) using `CodingKeys` enums.
- **AsyncImage**: I learned how to handle the different loading states (empty, success, failure) when loading remote images in SwiftUI.
- **API troubleshooting**: I learned to use `curl` in Terminal to inspect raw API responses before writing Swift code, which is a valuable debugging technique.
- **Cloudflare restrictions**: I discovered that some APIs block direct image requests from mobile apps using Cloudflare protection, and that the `lqip` base64 thumbnail can serve as a fallback.

---

## Question 3: What would you do differently, and what are the limitations of AI-assisted development?

**What I would do differently:**
- Research the API structure more thoroughly before starting to code. We spent significant time switching between APIs (Rijksmuseum Linked Art → Art Institute of Chicago) because the initial choice had an overly complex data format.
- Test API endpoints in Terminal with `curl` before writing any Swift code to confirm the JSON structure matches expectations.

**Limitations of AI-assisted development:**
- **AI can be confidently wrong**: Claude initially suggested API endpoints and registration links that returned 404 errors or didn't exist anymore, requiring manual verification.
- **No real-time knowledge**: AI doesn't always know when APIs have changed their structure, moved pages, or added Cloudflare protection.
- **Understanding vs. copying**: It's easy to paste code without fully understanding it. I had to slow down and ask follow-up questions to understand *why* certain patterns (like `@MainActor.run`) were used.
- **Image quality tradeoff**: The final app uses low-resolution `lqip` placeholder images because the full-resolution images are blocked by Cloudflare when requested from an iOS app — a limitation AI helped identify but couldn't fully solve.

