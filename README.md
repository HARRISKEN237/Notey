#  Notey — AI-Powered Student Notes App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white"/>
  <img src="https://img.shields.io/badge/Claude_API-D97757?style=for-the-badge&logo=anthropic&logoColor=white"/>
  <img src="https://img.shields.io/badge/Whisper_STT-412991?style=for-the-badge&logo=openai&logoColor=white"/>
</p>

<p align="center">
  <strong>Never miss a lecture again.</strong><br/>
  Notey helps students record, transcribe, and summarize lectures and class notes — powered by AI.
</p>

---

##  What is Notey?

**Notey** is a Flutter-based Android application designed specifically for students. It combines voice recording with AI-driven transcription and summarization to help you capture every important detail from lectures, study sessions, and group discussions — then condense them into clean, readable notes automatically.

###  Key Features

-  **Voice Notes** — Record lectures and class discussions directly in the app
-  **Noise Cancellation** — RNNoise AI-based noise suppression filters out classroom background noise
-  **Auto Transcription** — OpenAI Whisper converts your speech to accurate text
-  **AI Summary** — Claude API summarizes transcripts into structured, student-friendly notes
-  **Organize Notes** — Tag notes by subject, date, or course
-  **Cloud Sync** — Supabase backend keeps your notes safe and synced across devices
-  **Auth** — Secure login with Supabase Auth (email/password + Google OAuth)
- **Dark Mode** — Easy on the eyes during late-night study sessions

---

##  Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter (Dart) | Cross-platform UI & app logic |
| **Noise Cancellation** | RNNoise (via Dart FFI) | AI-based background noise removal |
| **Speech-to-Text** | OpenAI Whisper API | High-accuracy audio transcription |
| **AI Summarization** | Anthropic Claude API | Intelligent note summarization |
| **Backend & Auth** | Supabase | Database, Auth, File Storage |
| **Local Database** | Isar | Fast local storage for offline support |
| **State Management** | Riverpod | Reactive state management |
| **Audio Recording** | `record` package | Capture voice input |
| **Audio Playback** | `just_audio` | Play back recorded notes |

---

##  Architecture

```
┌─────────────────────────────────────────────┐
│                Flutter UI Layer              │
│         (Riverpod State Management)          │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│              Feature Modules                 │
│  ┌──────────┐ ┌──────────┐ ┌─────────────┐  │
│  │  Notes   │ │  Voice   │ │  AI Engine  │  │
│  │ Manager  │ │ Recorder │ │  (Summary)  │  │
│  └──────────┘ └────┬─────┘ └──────┬──────┘  │
└───────────────────-│──────────────│──────────┘
                     │              │
        ┌────────────▼───┐   ┌──────▼──────────┐
        │   RNNoise FFI  │   │   Claude API    │
        │ (Noise Filter) │   │  (Summarizer)   │
        └────────────────┘   └─────────────────┘
                     │
        ┌────────────▼───────┐
        │  Whisper API (STT) │
        │   (Transcription)  │
        └────────────────────┘
                     │
     ┌───────────────▼───────────────┐
     │         Data Layer            │
     │  ┌────────────┐ ┌──────────┐  │
     │  │    Isar    │ │Supabase  │  │
     │  │  (Local)   │ │ (Cloud)  │  │
     │  └────────────┘ └──────────┘  │
     └───────────────────────────────┘
```

---

##  Core Data Flow

```
 Microphone Input
       ↓
 RNNoise (FFI) — filters background noise in real-time
       ↓
 record package — saves clean .m4a audio file locally
       ↓
 OpenAI Whisper API — converts audio to raw transcript
       ↓
 Claude API — generates structured AI summary from transcript
       ↓
 Isar — stores note, transcript, summary & audio path locally
       ↓
 Supabase — syncs everything to the cloud
```

---

##  Project Structure

```
notey/
├── android/
│   ├── app/src/main/kotlin/
│   │   └── NoiseSuppressorPlugin.kt      # Native Android noise bridge
│   └── jniLibs/
│       └── arm64-v8a/librnnoise.so       # Compiled RNNoise binary
│
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── router.dart                   # GoRouter navigation
│   │   └── theme.dart                    # App theme & dark mode
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/login_screen.dart
│   │   │   └── providers/auth_provider.dart
│   │   │
│   │   ├── notes/
│   │   │   ├── screens/
│   │   │   │   ├── notes_list_screen.dart
│   │   │   │   ├── note_detail_screen.dart
│   │   │   │   └── create_note_screen.dart
│   │   │   ├── models/note_model.dart
│   │   │   └── providers/notes_provider.dart
│   │   │
│   │   ├── recorder/
│   │   │   ├── screens/recorder_screen.dart
│   │   │   ├── services/recorder_service.dart
│   │   │   └── providers/recorder_provider.dart
│   │   │
│   │   └── ai/
│   │       ├── services/
│   │       │   ├── whisper_service.dart  # STT via Whisper API
│   │       │   └── claude_service.dart   # Summarization via Claude
│   │       └── providers/ai_provider.dart
│   │
│   ├── core/
│   │   ├── ffi/
│   │   │   └── rnnoise_ffi.dart          # Dart FFI bindings for RNNoise
│   │   ├── supabase/
│   │   │   └── supabase_client.dart
│   │   └── local_db/
│   │       └── isar_service.dart
│   │
│   └── shared/
│       ├── widgets/
│       └── utils/
│
├── test/
│   ├── unit/
│   └── widget/
│
├── pubspec.yaml
└── README.md
```

---

##  Getting Started

### Prerequisites

- Flutter SDK `>=3.19.0`
- Dart SDK `>=3.3.0`
- Android Studio / VS Code
- Android device or emulator (API 21+)
- Supabase account — [supabase.com](https://supabase.com)
- OpenAI API key — [platform.openai.com](https://platform.openai.com)
- Anthropic API key — [console.anthropic.com](https://console.anthropic.com)

---

### 1. Clone the Repository

```bash
git clone https://github.com/Dark-storms45/Notey.git
cd notewise
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up RNNoise

RNNoise must be compiled as a shared library for Android:

```bash
# Clone RNNoise
git clone https://github.com/xiph/rnnoise.git
cd rnnoise

# Compile for Android ARM64 using NDK
export ANDROID_NDK=/path/to/your/android-ndk
./configure --host=aarch64-linux-android
make

# Copy the output .so to your project
cp .libs/librnnoise.so ../android/app/src/main/jniLibs/arm64-v8a/
```

### 4. Configure Environment Variables

Create a `.env` file in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
OPENAI_API_KEY=your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key
```

>  **Never commit your `.env` file.** Add it to `.gitignore`.

Use `flutter_dotenv` to load variables:

```dart
// main.dart
await dotenv.load(fileName: '.env');
```

### 5. Set Up Supabase

Run the following SQL in your Supabase SQL editor to set up the database schema:

```sql
-- Users table (handled by Supabase Auth)

-- Notes table
CREATE TABLE notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  transcript TEXT,
  summary TEXT,
  audio_url TEXT,
  subject TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their own notes"
  ON notes FOR ALL
  USING (auth.uid() = user_id);
```

Create a **Storage bucket** in Supabase named `audio-notes` for storing `.m4a` files.

### 6. Run the App

```bash
flutter run
```

---

##  Key Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Audio
  record: ^5.1.0              # Voice recording
  just_audio: ^0.9.38         # Audio playback
  path_provider: ^2.1.2       # File system paths

  # Networking
  http: ^1.2.1                # API calls (Whisper, Claude)
  dio: ^5.4.3                 # Advanced HTTP client

  # Backend
  supabase_flutter: ^2.3.4    # Supabase client

  # Local Storage
  isar: ^3.1.0                # Local database
  isar_flutter_libs: ^3.1.0
  hive_flutter: ^1.1.0        # Settings/preferences

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Utils
  flutter_dotenv: ^5.1.0      # Environment variables
  permission_handler: ^11.3.0 # Microphone permissions
  uuid: ^4.3.3                # Unique IDs

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  isar_generator: ^3.1.0
  riverpod_generator: ^2.4.0
```

---

##  RNNoise Integration (Dart FFI)

```dart
// lib/core/ffi/rnnoise_ffi.dart

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

final DynamicLibrary _rnnoiseLib = Platform.isAndroid
    ? DynamicLibrary.open('librnnoise.so')
    : DynamicLibrary.process();

typedef RnnStateCreateNative = Pointer Function();
typedef RnnStateCreate = Pointer Function();

typedef RnnProcessFrameNative = Float Function(Pointer state, Pointer<Float> output, Pointer<Float> input);
typedef RnnProcessFrame = double Function(Pointer state, Pointer<Float> output, Pointer<Float> input);

final RnnStateCreate rnnoiseCreate = _rnnoiseLib
    .lookup<NativeFunction<RnnStateCreateNative>>('rnnoise_create')
    .asFunction();

final RnnProcessFrame rnnoiseProcessFrame = _rnnoiseLib
    .lookup<NativeFunction<RnnProcessFrameNative>>('rnnoise_process_frame')
    .asFunction();
```

---

##  Claude AI Summarization

```dart
// lib/features/ai/services/claude_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClaudeService {
  static const _baseUrl = 'https://api.anthropic.com/v1/messages';

  static Future<String> summarizeTranscript(String transcript) async {
    final apiKey = dotenv.env['ANTHROPIC_API_KEY']!;

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-20250514',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': '''You are a helpful academic assistant for students.
Summarize the following lecture transcript into clear, structured student notes.
Use headings, bullet points, and highlight key concepts and definitions.

Transcript:
$transcript'''
          }
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data['content'][0]['text'] as String;
  }
}
```

---

##  Whisper Transcription

```dart
// lib/features/ai/services/whisper_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhisperService {
  static Future<String> transcribeAudio(String audioFilePath) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']!;
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
    );

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.fields['model'] = 'whisper-1';
    request.fields['language'] = 'en';
    request.files.add(
      await http.MultipartFile.fromPath('file', audioFilePath),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);
    return data['text'] as String;
  }
}
```

---

##  Required Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

---

##  Roadmap

- [x] Voice recording with noise cancellation
- [x] Whisper transcription
- [x] Claude AI summarization
- [x] Supabase cloud sync
- [x] Subject/course tagging system
- [x] Offline mode (full local-only support)
- [x] Export notes as PDF
- [ ] Flashcard generation from notes (Claude)
- [ ] Quiz generation from lecture notes
- [ ] Collaborative notes sharing between students
- [ ] iOS support

---

##  Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

Please follow the [Conventional Commits](https://www.conventionalcommits.org/) standard.

---

##  License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

##  Acknowledgements

- [RNNoise](https://github.com/xiph/rnnoise) by Mozilla/Xiph — AI noise suppression
- [OpenAI Whisper](https://openai.com/research/whisper) — Speech recognition
- [Anthropic Claude](https://anthropic.com) — AI summarization
- [Supabase](https://supabase.com) — Open-source backend
- [Flutter](https://flutter.dev) — UI framework

---

<p align="center">Built with love for students, by students.</p>
