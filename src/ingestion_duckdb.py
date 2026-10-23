from pathlib import Path
import dlt
from dlt.sources.filesystem import filesystem, read_csv

ROOT = Path(__file__).parents[1]

data_file = ROOT / "data" / "raw"
db_path = ROOT / "data" / "bronze" / "bestselling_books.duckdb"

files = filesystem(
    bucket_url=str(data_file),
    file_glob="international_bestsellers_dataset.csv"
    )

reader = (files | read_csv().with_name("b_bestselling_books"))

pipeline = dlt.pipeline(
    pipeline_name="csv_to_duckdb_bronze",
    dataset_name="bronze",
    destination=dlt.destinations.duckdb(str(db_path))
    )

info = pipeline.run(reader)
print(info)