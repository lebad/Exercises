# Exercises App Assessment Test

### Description

This app is UIKit-based with SwiftUI components. It is architected using the MVVM pattern and employs a reactive approach with the Combine framework. 
The minimum deployment target is iOS 15.0. It's developed using Xcode 15.2, and the Swift version is 5.9.2.

This app uses `CocoaPods` for dependency management. All pods are committed to the repo to ensure easy build and run setups.

### Architecture

The network layer is encapsulated within a service named `ExerciseService` responsible for CRUD operations with `ExerciseItem`. This could be further refactored to extract a generic `wger` API, which can then be utilized by other services.

`ViewModels` are designed to be independent of concrete service implementations, relying instead on protocol abstractions.

`ViewModels` contain the isolated logic for the app's screens, making them the focal point of the unit tests to ensure robustness and reliability.

### Set Up

To run the app, clone this repository and open the project in Xcode 15.2. It's not required to run `pod install` as all pods are committed into the repo, simplifying the build process.  
The project should compile without issues. If you encounter any problems, please contact me via email at `lebedac@gmail.com`.

### Efficient Loading

Data loading in the app is optimized to occur only when the corresponding screen is displayed. For efficient and cached image loading, the app utilizes the `Kingfisher` library.