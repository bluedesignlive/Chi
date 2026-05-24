    What to do now:

    1. ✅ ChiTimer example (DONE)
    2. 🔄 Build chi-template/ for npx create-chi-app or similar
    3. 🔄 Write the bootstrap script
    4. 🔄 Pick next example app (ChiMusic? ChiChat?)
    5. 🔄 Set up GitHub Discussions for show-and-tell
    6. 🔄 Write a blog post: "Why I built my own UI toolkit instead of using Qt Quick Controls"









 Good — the ChiTimer example is complete. Now the community playbook. This is the answer to "how do we build community over it":



    Chi Community Playbook

    Phase 1: Ship the Foundation (DONE)

    What we just delivered:
    - 30 component docs in doc/
    - AGENTS.md for AI agent context
    - chi-ui-toolkit skill for Hermes users
    - One working example app (ChiTimer)

    Phase 2: Make it Discoverable

    GitHub presence (suggest for your repo):
    markdown
    Chi UI Toolkit — Modern Material 3 for Qt6

    M3 Compatible
    Qt 6.5+
    License

    A Qt6/QML component library for Unix desktop.
    Shipped in a custom OS, not a distro.

    Getting Started · API Reference · Examples


    Key pages to add to your repo README:
    - "Why not Qt Quick Controls?" section
    - "Building a Chi app in 5 minutes" quickstart
    - Screenshot/GIF of ChiTimer running

    Phase 3: Lower the Barrier

    Three things that get people building:

    | Barrier              | Solution                    |
    |----------------------|-----------------------------|
    | "I don't know Qt"    | ChiTimer is the tutorial    |
    | "Setting up is hard" | Single-command build script |
    | "No docs exist"      | doc/ + AGENTS.md + skill    |

    Build script to write (next step if you want):

    bash
    #!/bin/bash
    chi-bootstrap — one-liner to get a Chi app running

    1. Clone (or symlink) this repo
    2. qmake / cmake build
    3. Open example or start new project from template


    Project template (next step):


    chi-template/               # npm init chi-app
    ├── qml/
    │   ├── Main.qml
    │   └── CMakeLists.txt
    └── README.md


    Phase 4: Content Flywheel

    The timer app is the first chapter. Build 4-5 more:

    1. ChiTimer — Stopwatch/clock (DONE)
    2. ChiMusic — Media player (ListView, progress bar, play/pause FAB)
    3. ChiChat — Messaging (messages list, text input, avatars)
    4. ChiNotes — Note app (cards, forms, dialogs, search)
    5. ChiWeather — Dashboard (stacked cards, icons, animated charts)

    Each app:
    - Single QML file, < 300 lines
    - Demonstrates 3-4 Chi components
    - Has a README with "what we learned"
    - Lives in examples/

    Phase 5: Community Touchpoints

    | Touchpoint         | What                                | Where                     |
    |--------------------|-------------------------------------|---------------------------|
    | Show and Tell      | People share what they built        | GitHub Discussions        |
    | Weekly builds      | Someone ships something with Chi    | Social / blog             |
    | Component requests | Users vote on missing components    | GitHub Issues with labels |
    | Theme sharing      | Users share custom color schemes    | PRs to themes/ dir        |
    | OS integrations    | Distros ship Chi as default toolkit | Your OS + allies          |

    Phase 6: The Narrative

    Your story is powerful. Frame it:

    > "Google controls Android's look. Apple controls iOS. We're building the design system that no corporation controls — because your OS should look like yours."

    Three pillars:
    1. Freedom — No gatekeepers, no walled gardens
    2. Craft — Every animation considered, every motion purposeful
    3. Unix — Built for the systems that power the internet

    This is the thing people share. Not "another UI toolkit." The story of independence.



    What to do now:

    1. ✅ ChiTimer example (DONE)
    2. 🔄 Build chi-template/ for npx create-chi-app or similar
    3. 🔄 Write the bootstrap script
    4. 🔄 Pick next example app (ChiMusic? ChiChat?)
    5. 🔄 Set up GitHub Discussions for show-and-tell
    6. 🔄 Write a blog post: "Why I built my own UI toolkit instead of using Qt Quick Controls"
