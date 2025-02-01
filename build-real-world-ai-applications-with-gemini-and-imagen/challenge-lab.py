import vertexai
from vertexai.preview.vision_models import ImageGenerationModel, Image
from vertexai.generative_models import GenerativeModel, Part

def generate_bouquet_image(prompt: str, output_file: str):
    """Generate an image using a text prompt and save it locally."""
    
    # Load the image generation model
    model = ImageGenerationModel.from_pretrained("imagegeneration@002")
    
    # Generate the image
    images = model.generate_images(
        prompt=prompt,
        number_of_images=1,
        seed=1,
        add_watermark=False,
    )
    
    # Save the image locally
    images[0].save(location=output_file)
    
    return images

def analyze_bouquet_image(image_path: str):
    """Analyze a bouquet image and generate birthday wishes using Gemini-Pro-Vision model."""
    
    # Load the model
    model = GenerativeModel("gemini-pro-vision")
    
    # Open the image file and read it as binary data
    with open(image_path, "rb") as image_file:
        image_data = image_file.read()
    
    # Create the Part object with the image data
    part = Part.from_data(data=image_data, mime_type="image/jpeg")  # or "image/png" depending on your image type
    
    # Generate response with streaming enabled
    response = model.generate_content(
        [
            part,
            "Generate a birthday wish based on this bouquet image."
        ]
    )
    
    return response.text

if __name__ == "__main__":
    PROJECT_ID = ""
    REGION_ID = ""
    OUTPUT_IMAGE = "image.jpeg"

    vertexai.init(project=PROJECT_ID, location=REGION_ID)
    
    generate_bouquet_image("Create an image containing a bouquet of 2 sunflowers and 3 roses", OUTPUT_IMAGE)
    print(analyze_bouquet_image(OUTPUT_IMAGE))

