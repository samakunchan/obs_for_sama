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

## 🚀 0.3.1 - 17/12/2024
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

