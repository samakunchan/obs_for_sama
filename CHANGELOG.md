## 🚀 0.13.0 - 14/02/2025
### Added

- Added a size for windows desktop platform (Surface pro purpose ect...).
- Added feature to keep screen active when the stream is started.
- Added a lifecyle controller to controller app's state.
- Added logout method applied to lifecycle.

### Changed

- Block scanner page for windows platform.
- Rename scanner controller.
- Added build runner and update ios/macos (i forgot why). 

### Fixed

- No fixes.


## 🚀 0.12.0 - 13/01/2025
### Added

- Added windows desktop configuration.
- Added icon windows.
- Added windows installer in `/release` folder.

### Changed

- Disabled QR code for windows.
- Refacto structure release folder.

### Fixed

- No fixes.


## 🚀 0.11.1 - 13/01/2025
### Added

- No Addition.

### Changed

- Added a controller to manage the `MobileScanner` widget.

### Fixed

- Disabled impeller in `/android/app/src/main/AndroidManifest.xml`.


## 🚀 0.11.0 - 10/01/2025
### Added

- Architecture MVVM came, we saw and remove it. It's a waste of time with GetX.
- Added dependencies for lock the screen while the stream is started
- Added workflow to build automatically apk to github.

### Changed

- Change structures controller.
- Added locale.
- Added doc for splash screen in `main.dart` file.

### Fixed

- Fix sound issue for window. (Need to be aware with people who use Linux to stream).

## 🚀 0.10.0 - 30/12/2024
### Added

- Added `flutter_native_splash` package and configuration for ios/android.
- Added `flutter_launcher_icons` package and configuration for ios/android.
- Added assets splash screens and icon.

### Changed

- No Changes.

### Fixed

- No Fixes.


## 🔨 0.9.1 - 29/12/2024
### Added

- No addition.

### Changed

- No Changes.

### Fixed

- Added forbidden file : `SettingLayoutDefault` widget.


## 🚀 0.9.0 - 29/12/2024
### Added

- No addition.

### Changed

- Added animation for home route to disable the default animation.
- Rename file `r_s_i_outlined_body.dart`.
- Added all features for IPad.

### Fixed

- No fixes.

 
## 🚀 0.8.0 - 29/12/2024
### Added

- Added font awesome package.

### Changed

- Deleted submit qr code method because its a duplication.
- Added setting layout mobile widget.
- Added widget for QR code page.
- Added widget for regular form page.
- Refacto OBS setting page.

### Fixed

- No fixes.


## 🚀 0.7.0 - 28/12/2024
### Added

- No add.

### Changed

- Added a form controller.
- Added an error controller.
- Removing old code from server controller.
- Updated widgets with new controllers

### Fixed

- No fixes.


## 🚀 0.6.0 - 28/12/2024
### Added

- No add.

### Changed

- Added GetX routes instead of Flutter routes.
- Binding DI to routes.
- Added transition to the route to `SettingsPage`.
- Updated layout to stateless classes.
- Removed old instantiation of `ServerController`, and added the DI to widgets and controllers.

### Fixed

- No fixes.


## 🔨 0.5.1 - 28/12/2024
### Added

- No add.

### Changed

- Added new method to detect the source name of the microphone in the `SoundController` .
- Added the detection to the connection/reload process.

### Fixed

- No fixes.


## 🚀 0.5.0 - 28/12/2024
### Added

- Added routes class for separate all pages.
- import routes files to MyApp widget.
- Added pages folder for all pages.
- Added setting page to manage to connection to OBS
- Installing packages for QR codes

### Changed

- Home property disabled.
- Moved obs control page.
- Deleted dialog popup and moved the form to the new setting page.
- Updated "submit" method with require onFailure/onSuccess callback.
- Added a submit method only for QR code.
- Fixed issue for the 1st time verification of failure.
- Added a new Exception to handle timeout
- Transformed all layout in stateful widget for the moment.

### Fixed

- Fixed issues for ios configuration.


## 🚀 0.4.0 - 23/12/2024
### Added

- Added failures classes to manage errors.
- Added snackbar to display errors to screen.

### Changed

- Changed app name inside gradle.
- Updated java version, ndkVersion, gradle version adn gradle distribution.
- Updated Readme to remember the previous change.
- Update `ServerController` to managa failures.

### Fixed

- No fixes.


## 🔨 0.3.1 - 17/12/2024
### Added

- Added a new button to toogle the start/stop stream.
- Added the new button to the default and action button.

### Changed

- Added event to listen the stream status (start/loading/stop).
- Added StatusStream and replace old version with boolean.
- Remove `.then()` for `startStreaming()` and `stopStreaming()`.
- Rename `isConnected()` method to `isOBSConnected()`

### Fixed

- Fixed issue about the refresh of start button and stop button when it pressed.


## 🚀 0.3.0 - 13/12/2024
### Added

- Added state manager getX.
- Added a new enums to manage static text in the app.
- Added controllers GetX (server, cache, scenes, sources, sound) to manage datas.
- Added action buttons default and action buttons mobile.
- Added a short Readme.

### Changed

- Update path for integration test.
- Added back Text button theme.
- Refacto structures of projects.
- Updated main view to contain a mobile version.

### Fixed

- No fix.


## 🚀 0.2.0 - 09/12/2024
### Added

- Added font package and storage package.
- Added network connection for google fonts to android and ios.
- Added constante for : colors, fonts, and theme.
- Added enum for settings values.
- Added 1st version of clipper button and card
- Added widgets : `ErrorMessageScreen`, `HeaderMediumTextButton`, `RSIButton` and `RSIButtonOutlined`.
- Build app responsive app.

### Changed

- Delete useless env file.
- Update gradle.
- Update podfile

### Fixed

- No fix.


## 🚀 0.1.0 - 21/08/2024
### Added

- Added `.env` files for protected information.
- Added linter to format code.

### Changed

- No change.

### Fixed

- No fix.

