# Agent notes for Enjoyable

Guidance for agents working in this repo.

## Working here

- Use the Xcode MCP tools (`BuildProject`, `RunProject`, `XcodeRead`,
  `XcodeWrite`, `XcodeUpdate`, `XcodeGrep`, `XcodeGlob`,
  `GetTargetBuildSettings`, `UpdateTargetBuildSetting`, ...) rather than
  shell commands where they exist.
- Build: `BuildProject`. Run the app: `RunProject` (use
  `GetConsoleOutput` for the app's console log).

## Build notes

- The project targets macOS 27 and is built with warnings treated as
  errors (`GCC_TREAT_WARNINGS_AS_ERRORS` plus `-Werror` on many clang
  warnings). New code must compile warning-free; avoid deprecated APIs.
- The project was migrated off deprecated APIs — see the pattern in
  `Enjoyable/Categories/NSRunningApplication+LoginItem.m`:
  `LSSharedFileList` → `SMAppService`, `CVDisplayLink` →
  `CADisplayLink` (`NSScreen`/`NSView`/`NSWindow`.
  `displayLinkWithTarget:selector:`), `NSFilesPromisePboardType` →
  `kPasteboardTypeFileURLPromise`, `NSURLPBoardType` →
  `NSPasteboardTypeURL`, etc. If you add an API and get a
  deprecated-warning error, replace it with the modern equivalent from the
  SDK headers.

## Layout

- `Enjoyable/Classes/Input/` — input model: `NJInputController` (mapping
  state and HID wiring), `NJDevice`, `NJInput`, `NJInputPathElement`,
  `NJMapping`, `NJInputAnalog`, `NJInputButton`, `NJInputHat`.
- `Enjoyable/Classes/Output/` — output model: `NJOutputKeyPress`,
  `NJOutputMouseMove/Button/Scroll`, `NJOutputMapping`.
- `Enjoyable/Classes/View Controllers/` — `NJMappingsViewController` (the
  mapping list with drag and drop), `NJDeviceViewController`,
  `NJOutputViewController`.
- `Enjoyable/Classes/Views/NJKeyInputField` — key-code entry field.
- `Enjoyable/Categories/` — small helpers, including login item management
  and `NSRunningApplication` possible mapping names.
- `Enjoyable/Resources/` — status bar icons and help pages.

## Common tasks

- Fixing a deprecated build failure: run `BuildProject`, find the file and
  symbol in the errors, replace with the modern API. SDK headers are at
  `/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/`.
- Testing: `RunProject` and read the log with `GetConsoleOutput`;
  `XcodeRefreshCodeIssuesInFile` for quick per-file diagnostics.
- Linking new frameworks: `UpdateTargetBuildSetting` with
  `OTHER_LDFLAGS` (e.g. `-framework UniformTypeIdentifiers`).
