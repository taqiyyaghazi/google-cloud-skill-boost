#!/bin/bash

export API_KEY= <YOUR API KEY>
# Task 2. Create synthetic speech from text using the Text-to-Speech API
FILENAME_REQUEST= <REPLACE FILENAME>
FILENAME_RESPONSE= <REPLACE FILENAME>

curl -H "Content-Type: application/json; charset=utf-8" \
  -d @$FILENAME_REQUEST "https://texttospeech.googleapis.com/v1/text:synthesize?key=${API_KEY}" \
  > $FILENAME_RESPONSE

python tts_decode.py --input $FILENAME_RESPONSE --output "synthesize-text-audio.mp3"

# Task 3. Perform speech to text transcription with the Cloud Speech AP
data='{
  "config": {
    "encoding":"FLAC",
    "languageCode": "fr-FR",
    "audioChannelCount": 1
  },
  "audio": {
    "uri":"gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}'
FILENAME_REQUEST= <REPLACE FILENAME>
FILENAME_RESPONSE= <REPLACE FILENAME>

echo "$data" > "$FILENAME_REQUEST"

curl -s -X POST -H "Content-Type: application/json" --data-binary @$FILENAME_REQUEST \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > $FILENAME_RESPONSE

# Task 4. Translate text with the Cloud Translation API
TEXT="これは日本語です。"
FILENAME="translated_response.txt"

# URL-encode the text (THIS IS THE CRITICAL STEP)
ENCODED_TEXT=$(echo "$TEXT" | python3 -c "import urllib.parse; print(urllib.parse.quote(input()))")

# Use the encoded text in the curl command
curl "https://translation.googleapis.com/language/translate/v2?target=en&key=${API_KEY}&q=${ENCODED_TEXT}" > "$FILENAME"


# Task 5. Detect a language with the Cloud Translation API
TEXT= <TEXT>
FILENAME= <FILENAME>
curl -X POST "https://translation.googleapis.com/language/translate/v2/detect?key=${API_KEY}" -d "q=${TEXT}" > $FILENAME
