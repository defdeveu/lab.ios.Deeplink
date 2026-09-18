# Deeplink lab

An iOS teaching application that demonstrates how an app receives and
interprets links opened from outside its own user interface.

## Requirements

- Xcode 27 or newer on Apple silicon;
- iOS 17 or newer; and
- Safari or another app capable of opening a registered URL scheme for manual
  integration checks.

Open `lab.ios.Deeplink.xcodeproj` and run the `lab.ios.Deeplink` scheme. The
XCTest target covers URL interpretation and presentation state without relying
on another process. Use Simulator URL opening for the end-to-end acceptance
check.

This repository currently provides `master.challenge` as the hands-on starting
point. Detailed challenge behavior and instructor guidance are intentionally
kept out of the client repository.
