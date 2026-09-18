# Run the exercise

1. From the repository root, open the project:

   ```sh
   open lab.ios.Deeplink.xcodeproj
   ```

2. In Xcode, select the `lab.ios.Deeplink` scheme.
3. Select an installed iPhone Simulator running iOS 17 or newer.
4. Run the app with `⌘R`.
5. With the app installed and the Simulator booted, open a test link:

   ```sh
   xcrun simctl openurl booted 'defdev://sample?view'
   ```

6. Run the included tests with `⌘U`.
