# Overview

A sample project demonstrating the process execution behavior of shared App Intents across multiple targets.

# Process Rule

The behavior described below is not documented in the official Apple documentation.
It is based on observed runtime behavior.

## Precondition

- Runs on iOS 26.1
- Build with Xcode 26.2
- A module that contains intents is linked to an app target and a widget target.
    - see sample project for more detail about environment.
    
Although the sample uses a widget, the same behavior appears to apply to other app extensions and potentially other OS versions as well.

## Rule

1. If the intent is an OpenIntent, it always runs in the app’s process. regardless of:
    - whether the app or widget is active
    - the source that triggered the intent
2. If an intent is triggered from a project's target (app or widget), it runs in the same process as the triggering target.
3. If an intent is triggered from outside the app (e.g. Siri, Shortcuts, Spotlight):
    1. If the app is alive (foreground or background), the intent runs in the app’s process.
    2. If the app is terminated, the intent runs in the widget’s process.

## Evidence

| Rule 1 | Rule 2 | Rule 3 | 
|---|---|---|
|<video width=300 src="https://github.com/user-attachments/assets/599fea0a-98b9-4384-a2cc-fad156619aa6">|<video width=300 src="https://github.com/user-attachments/assets/cbda96ea-3922-4ead-9c89-dc61ae94d679">|<video width=300 src="https://github.com/user-attachments/assets/0367507e-4b99-44a3-9e36-a0b3958e2291">|

### Rule 1
- triggered `OpenIntent` from shortcut while app is alive. 
- triggered the intent from shortcut while app is terminated. 
- triggered the intent from widget. 

-> all run on app's process.

### Rule 2

- triggered `SearchItemIntent` from widget -> runs on widget's process. 
- triggered the intent from app -> runs on app's process.

(`SearchItemIntent` is a intent which is not conforming to `OpenIntent`)

### Rule 3
- triggered `SearchItemIntent` from shortcut while app is alive -> runs on app's process
- triggered the intent from shortcut while app is terminated -> runs on widget's process.
