# free_dict

English dictionary app connected to (Free Dictionary API)[https://dictionaryapi.dev/]

## Features:
- Login/Signup
- Audio pronunciation of the word (if provided by Free Dictionary API)
- Every word from the english dictionary
- User related history (words user accessed definitions)
- User related favorite words (words user marked as favorite)
- Cache API responses

## Tech Stack
- App: Flutter
- State Management: Riverpod
- Dependency Injection: GetIt
- Local backend: SQFLite
- Layout: Material Design 3

## Instructions
- Clone the repository
`git clone https://github.com/huggo-42/free-dict.git`

> to use `make` in linux, you'll need build-essential package
- Run the app
`make run` or `flutter run`

- Build the app
`make build` or `flutter build apk`

- Generate Riverpod files
`make riverpod` or `dart run build_runner build`

## TODOs :(
- [ ] Apply clean code and clean architecture to the rest of the project
- [ ] Implement unit tests and integration tests

> This is a challenge by Coodesh
