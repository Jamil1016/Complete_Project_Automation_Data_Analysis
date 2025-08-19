import shutil
import os
from dotenv import load_dotenv
from pathlib import Path
from datetime import datetime

load_dotenv()

source_folder = Path(os.getenv("path_to_upload"))
destination_folder = Path(os.getenv("path_already_uploaded"))

for filename in os.listdir(source_folder):
    source_path = os.path.join(source_folder, filename)
    
    if os.path.isfile(source_path):
        # Split filename and extension
        name, ext = os.path.splitext(filename)
        
        # Create timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # New filename with timestamp
        new_filename = f"{name}_{timestamp}{ext}"
        
        # Destination path
        destination_path = os.path.join(destination_folder, new_filename)
        
        # Move + rename
        shutil.move(source_path, destination_path)
        print(f"Moved: {filename} → {new_filename}")