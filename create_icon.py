#!/usr/bin/env python3
from PIL import Image
import os

def create_app_icons():
    """Create app icons in various sizes from the provided image"""
    
    # You'll need to save the image first
    input_path = "/Users/KoichiOkawa/Desktop/SleepingCat/icon_original.png"
    
    if not os.path.exists(input_path):
        print(f"Please save the icon image to: {input_path}")
        return
    
    # Load and prepare the image
    img = Image.open(input_path)
    
    # macOS icon sizes
    sizes = [16, 32, 64, 128, 256, 512, 1024]
    
    # Create Icons directory
    os.makedirs("Icons", exist_ok=True)
    
    for size in sizes:
        # Resize with high quality
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        
        # Save individual size
        output_path = f"Icons/icon_{size}x{size}.png"
        resized.save(output_path)
        print(f"Created: {output_path}")
        
        # Also save @2x version for Retina
        if size <= 512:
            retina_size = size * 2
            retina = img.resize((retina_size, retina_size), Image.Resampling.LANCZOS)
            retina_path = f"Icons/icon_{size}x{size}@2x.png"
            retina.save(retina_path)
            print(f"Created: {retina_path}")
    
    print("\nAll icon sizes created!")
    print("Next step: Use 'iconutil' to create .icns file")

if __name__ == "__main__":
    create_app_icons()