# Project Infratrack - Admin Portal Build and Run Instructions

This document provides instructions for setting up, running, and troubleshooting the Admin Portal Flutter application.

## Prerequisites

Before building and running the application, ensure you have the following prerequisites installed and configured:

1.  **Git:** Required for cloning the repository.
2.  **Java Development Kit (JDK):** Flutter's Android build process requires a JDK. Java 21 or a compatible version is recommended.
3.  **Flutter SDK:** The Flutter SDK is necessary for building Flutter applications. Version 3.29.2 or later is recommended.
4.  **Android SDK (if building for Android):** If you intend to run the application on an Android emulator or device, you'll need the Android SDK.

## Setup

1.  **Clone the Repository:**

    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

    Replace `<repository_url>` with the URL of your repository and `<repository_directory>` with the name of the directory you want to clone into.

2.  **Install JDK (if not already installed):**

    * Download and install a compatible JDK (e.g., Zulu JDK).
    * Set the `JAVA_HOME` environment variable to the JDK installation directory.
    * Add the JDK's `bin` directory to your system's `PATH` environment variable.

3.  **Install Flutter SDK (if not already installed):**

    * Download the Flutter SDK from the official Flutter website ([flutter.dev](flutter.dev)).
    * Extract the SDK to a suitable location.
    * Add the Flutter `bin` directory to your system's `PATH` environment variable.
    * Run `flutter doctor` to verify the installation and identify any missing dependencies.

4.  **Install Android SDK (if building for Android):**

    * Download and install Android Studio.
    * Configure the Android SDK using Android Studio's SDK Manager.
    * Set the `ANDROID_HOME` environment variable to the Android SDK installation directory.
    * Add the Android SDK's `platform-tools` and `tools` directories to your system's `PATH` environment variable.
    * Accept Android SDK licenses by running `flutter doctor --android-licenses`.

## Running the Application (Locally)

To run the Flutter application locally:

1.  **Navigate to the Application Directory:**

    ```bash
    cd <your_project_directory>
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Clean the Build Directory (Recommended):**

    ```bash
    flutter clean
    ```

4.  **Install Dependencies (Again):**

    ```bash
    flutter pub get
    ```

5.  **Run the Application:**

    * **On an Android emulator or device:**

        ```bash
        flutter run
        ```

    * **On an iOS simulator or device:**

        ```bash
        flutter run
        ```

    * **On a web browser:**

        ```bash
        flutter run -d chrome
        ```

    Select the appropriate device or emulator from the list displayed by the `flutter run` command.

## Error Handling

* **`flutter pub get` errors:**
    * Check your internet connection.
    * Delete the `pubspec.lock` file and run `flutter pub get` again.
    * Ensure your Flutter SDK is correctly installed and configured.
    * Verify that your Flutter version is compatible with the project's dependencies.
* **`flutter build apk` errors:**
    * Verify your Android SDK setup and licenses (run `flutter doctor --android-licenses`).
    * Ensure the `ANDROID_HOME` environment variable is set correctly.
    * Check that the Android build tools and platform tools are installed.
* **Java errors:**
    * Verify that your Java version is correct.
    * Verify that the `JAVA_HOME` environment variable is set correctly.
* **Device errors:**
    * Ensure that the device or emulator you are using is correctly set up.
    * Ensure that the device or emulator is connected to your computer.
* **Other build errors:**
    * Consult the Flutter documentation for specific error messages.
    * Check the output of `flutter doctor`.
    * Search online forums and communities for solutions.
