import requests
import io
from PIL import Image
from flask import Flask, request, jsonify

app = Flask(__name__)

# API URL for your chosen model (replace with the actual model URL)
MODEL_API_URL = "https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-large"
MODEL_HEADERS = {"Authorization": "Bearer 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"}

@app.route("/caption", methods=["POST"])
def generate_caption():
    image_file = request.files["image"]

    if image_file:
        with open(image_file.filename, "wb") as f:
            f.write(image_file.read())

        with open(image_file.filename, "rb") as f:
            image_data = f.read()
        # Read image content as bytes
        # image_bytes = io.BytesIO(image_file.read())
        # image = Image.open(image_bytes)

        model_response = requests.post(MODEL_API_URL, headers=MODEL_HEADERS, data=image_data)

        # Handle potential errors from the model API
        if model_response.status_code != 200:
            return jsonify({"error": f"Error from model API: {model_response.text}"}), 500

        # Extract the caption from the model response (assuming the structure)
        try:
            caption = model_response.json()[0]["generated_text"]  # Assuming first element contains caption
            caption = caption.capitalize()
        except (IndexError, KeyError):
            return jsonify({"error": "Failed to parse model response for caption"}), 500

        # Return the desired JSON response format
        return jsonify({"caption": caption})

    else:
        return jsonify({"error": "No image file uploaded"}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8095)  # Adjust port as needed