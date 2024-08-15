# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:07f2883218700e144d55fa8f042fe8b6eb88ba0f80c713a560ae9ef72b46ba7e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f60f5740fefb47ac3120e2f752819b16947ce9085ef30ed49e3a71bb272cd0b7

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
