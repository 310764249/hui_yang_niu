# Tencent Cloud ASR configuration

The AI chat input uses Tencent Cloud real-time speech recognition over WebSocket.
Audio is sent as mono, 16 kHz, 16-bit PCM, matching the Tencent Cloud API
requirements.

## Production authorization

Do not put a permanent Tencent Cloud `SecretKey` in the application. The app
requests a short-lived signed WebSocket URL from:

```text
GET /api/chat/speech/authorization?voiceId=<unique-request-id>
```

The authenticated API response data must contain:

```json
{
  "websocketUrl": "wss://asr.cloud.tencent.com/asr/v2/..."
}
```

The backend should use a restricted CAM role, sign the supplied `voiceId`, and
set the signature lifetime to a few minutes. A different path can be configured
with:

```text
--dart-define=TENCENT_ASR_AUTH_PATH=/api/chat/speech/authorization
```

## Local development only

Direct credentials are supported for local debugging:

```text
--dart-define=TENCENT_ASR_AUTH_PATH=
--dart-define=TENCENT_ASR_APP_ID=...
--dart-define=TENCENT_ASR_SECRET_ID=...
--dart-define=TENCENT_ASR_SECRET_KEY=...
--dart-define=TENCENT_ASR_TOKEN=...
```

These values are compiled into the app. Never use this mode for a production
build.
