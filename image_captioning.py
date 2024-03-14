from transformers import VisionEncoderDecoderModel, ViTFeatureExtractor, AutoTokenizer
import torch
from PIL import Image

# Load the model and tokenizer
model_name = "nlpconnect/vit-gpt2-image-captioning"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = VisionEncoderDecoderModel.from_pretrained(model_name)
feature_extractor = ViTFeatureExtractor.from_pretrained(model_name)

# Define a function to generate captions for a local image
def generate_caption_local(image_path):
    # Load the image using PIL
    image = Image.open(image_path)
    
    # Preprocess the image using the feature extractor
    inputs = feature_extractor(images=image, return_tensors="pt")

    # Generate captions using the model
    output = model.generate(**inputs)
    caption = tokenizer.batch_decode(output, skip_special_tokens=True)[0]
    return caption

# Specify the path to your image
image_path = "/Users/shashank/Desktop/Vision-Walk-HCI/test5.jpg"  # Replace with the actual path

# Generate the caption and print it
caption = generate_caption_local(image_path)
print("Caption:", caption)
