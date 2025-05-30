#!/usr/bin/env python3

import os
import sys
from pathlib import Path
from rembg import remove
from PIL import Image
from tqdm import tqdm

def process_frames(input_dir, output_dir):
    """Remove backgrounds from all PNG frames in input directory"""
    
    # Create output directory if it doesn't exist
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    # Get all PNG files
    input_path = Path(input_dir)
    png_files = sorted(list(input_path.glob("*.png")))
    
    if not png_files:
        print(f"No PNG files found in {input_dir}")
        return
    
    print(f"Found {len(png_files)} PNG files to process")
    
    # Process each file
    for png_file in tqdm(png_files, desc="Removing backgrounds"):
        try:
            # Read input image
            input_image = Image.open(png_file)
            
            # Remove background
            output_image = remove(input_image)
            
            # Save output with same filename
            output_path = Path(output_dir) / png_file.name
            output_image.save(output_path, "PNG")
            
        except Exception as e:
            print(f"\nError processing {png_file.name}: {e}")
            continue
    
    print(f"\nCompleted! Processed images saved to {output_dir}")

if __name__ == "__main__":
    # Default paths
    input_dir = "/Users/KoichiOkawa/Downloads/cat_frames"
    output_dir = "/Users/KoichiOkawa/Downloads/cat_frames_no_bg"
    
    # Allow command line arguments
    if len(sys.argv) > 1:
        input_dir = sys.argv[1]
    if len(sys.argv) > 2:
        output_dir = sys.argv[2]
    
    process_frames(input_dir, output_dir)