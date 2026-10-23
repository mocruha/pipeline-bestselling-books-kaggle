from pathlib import Path
import shutil
import kagglehub

# Download latest version
path = kagglehub.dataset_download(
    "mnkaggler/international-bestselling-books-market-trends")

print("Path to dataset files:", path)

project_root = Path(__file__).resolve().parents[1]
target_dir = project_root / "data" / "raw"
target_dir.mkdir(parents=True, exist_ok=True)

for file_path in Path(path).iterdir():
    if file_path.is_file():
        shutil.copy(file_path, target_dir / file_path.name)
        print(f"Copied {file_path.name} to {target_dir}")

