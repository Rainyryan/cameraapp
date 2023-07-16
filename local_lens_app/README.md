# LocalLens flutter project

this is the project root

## Good to knows
* Project codes are mainly in './lib' directory
* './lib/api' contains our custom api files
* 
### Pub and pubspec.yaml
* pub is the package manager for the Dart programming language, just like pip for python, containing reusable libraries & packages for Flutter, AngularDart, and general Dart programs.
* 'pubspec.yaml' (pub specification) file specifies dependencies that the project requires, such as particular packages (and their versions), fonts, or image files. It also specifies other requirements, such as dependencies on developer packages (like testing or mocking packages), or particular constraints on the version of the Flutter SDK. pub reads this file and configure the project accordingly.

Usages:
* 'flutter pub get' fetches and downloads the dependencies specified in the 'pubspec.yaml' file
* 'flutter pub upgrade' upgrades the project dependencies to their latest versions, based on the constraints defined in the pubspec.yaml file
* 'flutter pub outdated' lists the dependencies in your project that have newer versions available
* 'flutter pub add <package_name>' adds a new package to your Flutter project. It updates the 'pubspec.yaml' file and fetches the package from the pub.dev repository.
* 'flutter pub remove <package_name>' undos 'flutter pub add', removes a package from your Flutter project. It updates the pubspec.yaml file and removes the package's dependencies from your project. 

### CocoaPods and Podfile
* CocoaPods is a dependency manager for iOS and macOS projects. It is specifically designed for managing third-party libraries and frameworks in Objective-C, Swift, or mixed-language projects. CocoaPods simplifies the process of integrating external libraries into iOS and macOS applications by providing a centralized repository of open-source libraries.
* './ios/Podfile' is used to declare the dependencies (libraries and frameworks) that your iOS or macOS project needs. It specifies which external libraries should be installed and managed by CocoaPods. The Podfile also allows you to define the desired versions or version ranges for each dependency.

## File Structure
```
.
├── README.md
├── analysis_options.yaml # Analyzer configuration settings
├── android
│   ├── app/ # Android application source code and resources
│   ├── build.gradle # Gradle build configuration for Android
│   ├── gradle/ # Gradle wrapper files
│   ├── gradle.properties # Gradle properties file
│   └── settings.gradle # Android project settings
├── ios
│   ├── Flutter/ # Flutter-specific iOS configuration files
│   ├── Podfile # iOS dependency configuration with CocoaPods
│   ├── Podfile_ # Backup of the original Podfile
│   ├── Runner/ # iOS application source code and resources
│   ├── Runner.xcodeproj # Xcode project file
│   ├── Runner.xcworkspace # Xcode workspace file
│   └── RunnerTests/ # iOS unit tests
├── lib
│   ├── api/ # Our custom api files
│   ├── google_ml_kit_text_detection/ # Modified files for Google ML Kit text detection
│   └── main.dart
├── linux
│   ├── CMakeLists.txt # CMake build configuration for Linux
│   ├── flutter/ # Flutter-specific Linux configuration files
│   ├── main.cc # Main C++ source file for Linux
│   ├── my_application.cc # Custom application class implementation for Linux
│   └── my_application.h # Custom application class header for Linux
├── macos
│   ├── Flutter/ # Flutter-specific macOS configuration files
│   ├── Podfile # macOS dependency configuration with CocoaPods
│   ├── Runner/ # macOS application source code and resources
│   ├── Runner.xcodeproj # Xcode project file for macOS
│   ├── Runner.xcworkspace # Xcode workspace file for macOS
│   └── RunnerTests/ # macOS unit tests
├── pubspec.lock # Generated file specifying dependency versions
├── pubspec.yaml # Flutter project configuration
├── test
│   └── translate_test.dart # Dart unit test file
├── web
│   ├── favicon.png # Web app icon file
│   ├── icons/ # Icons and images for the web app
│   ├── index.html # Entry HTML file for the web app
│   └── manifest.json # Manifest file for Progressive Web Apps
└── windows
    ├── CMakeLists.txt # CMake build configuration for Windows
    ├── flutter/ # Flutter-specific Windows configuration files
    └── runner # Entry point for the Windows application

```
