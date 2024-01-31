# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9003bcb5de882c3b023314580cd7600b2e2baf3cd45d78e3cb50a8060771d207 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8bb99f50ffe6be4d6ce0f0ff415d6613cb03a98db10219892c55c88aa6a3d881

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
