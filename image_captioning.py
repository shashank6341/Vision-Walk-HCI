from transformers import VisionEncoderDecoderModel, ViTFeatureExtractor, AutoTokenizer
import torch
from PIL import Image
import io  # For handling images as bytes
from flask import Flask, request, jsonify  # For creating a basic server

# Load the model and tokenizer (place outside the function for efficiency)
model_name = "nlpconnect/vit-gpt2-image-captioning"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = VisionEncoderDecoderModel.from_pretrained(model_name)
feature_extractor = ViTFeatureExtractor.from_pretrained(model_name)

app = Flask(__name__)  # Initialize the Flask server

@app.route('/caption', methods=['POST'])
def generate_caption_server():
    # Validate input format and handle errors gracefully
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400  # Bad request

    image_file = request.files['image']

    try:
        # Read image content as bytes
        image_bytes = io.BytesIO(image_file.read())
        image = Image.open(image_bytes)

        # Preprocess the image using the feature extractor
        inputs = feature_extractor(images=image, return_tensors="pt")

        # Generate captions using the model
        output = model.generate(**inputs)
        caption = tokenizer.batch_decode(output, skip_special_tokens=True)[0]

        return jsonify({'caption': caption})
    except Exception as e:
        print(f"Error processing image: {e}")
        return jsonify({'error': 'Failed to process image'}), 500  # Internal server error

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001)  # Run the server on all interfaces (0.0.0.0)
