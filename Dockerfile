# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:be53599057a23c17809fd79b387905c13f05327ba30e0b353b03f771dd32d4d9 as builder

WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt --user

# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8eb266ac46896dd7cf17da76164517fe4eb252b33a12031f202054eac403f8bc

WORKDIR /app

# Make sure you update Python version in path - has to be manually changed whenever Chainguard updates their Python pac>COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages

COPY main.py .

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
