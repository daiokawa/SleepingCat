#!/usr/bin/env python3
from PIL import Image
import numpy as np

def process_icon():
    """Process icon to crop blue background and enlarge cat"""
    
    # Load the original icon
    img = Image.open("icon_original.png")
    img_array = np.array(img)
    
    # Find the bounds of the cat (non-blue area)
    # The blue background appears to be the dominant color
    h, w = img_array.shape[:2]
    
    # Ensure we have RGBA
    if img_array.shape[2] == 3:  # If RGB
        # Add alpha channel
        alpha = np.ones((h, w, 1), dtype=np.uint8) * 255
        img_array = np.concatenate([img_array, alpha], axis=2)
    
    rgb_array = img_array[:, :, :3]
    
    # Find the blue rounded square area (not the beige background)
    # The beige/paper background is approximately (230-255, 220-240, 200-220)
    mask = np.zeros((h, w), dtype=bool)
    
    for y in range(h):
        for x in range(w):
            r, g, b = rgb_array[y, x]
            # If it's NOT beige background, keep it
            if not (r > 220 and g > 210 and b > 190):
                mask[y, x] = True
    
    # Find bounding box of the cat
    rows = np.any(mask, axis=1)
    cols = np.any(mask, axis=0)
    
    if rows.any() and cols.any():
        ymin, ymax = np.where(rows)[0][[0, -1]]
        xmin, xmax = np.where(cols)[0][[0, -1]]
        
        # Add minimal padding since we're cropping the beige background
        padding = 10
        ymin = max(0, ymin - padding)
        ymax = min(h, ymax + padding)
        xmin = max(0, xmin - padding)
        xmax = min(w, xmax + padding)
        
        # Crop the image
        cropped = img_array[ymin:ymax, xmin:xmax]
        
        # Create a new square image with the cat centered
        cat_h, cat_w = cropped.shape[:2]
        size = max(cat_h, cat_w)
        
        # Create new image with blue background
        new_img = np.zeros((size, size, 4), dtype=np.uint8)
        # Fill with the nice blue from original
        new_img[:, :] = [66, 124, 185, 255]  # Approximate blue color
        
        # Center the cat
        y_offset = (size - cat_h) // 2
        x_offset = (size - cat_w) // 2
        
        # Place the cropped cat
        new_img[y_offset:y_offset+cat_h, x_offset:x_offset+cat_w] = cropped
        
        # Save the processed icon
        result = Image.fromarray(new_img, 'RGBA')
        result.save("icon_processed.png")
        
        print(f"Icon processed: {size}x{size}")
        print("Saved as icon_processed.png")
        
        # Also create a version with transparent background
        # Make blue pixels transparent
        transparent = new_img.copy()
        for y in range(size):
            for x in range(size):
                r, g, b, a = transparent[y, x]
                if r < 100 and g < 150 and b > 150:
                    transparent[y, x, 3] = 0  # Make transparent
        
        result_transparent = Image.fromarray(transparent, 'RGBA')
        result_transparent.save("icon_transparent.png")
        print("Also saved transparent version as icon_transparent.png")
        
    else:
        print("Could not find cat bounds")

if __name__ == "__main__":
    process_icon()