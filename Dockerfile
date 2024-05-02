# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f25d56d44a0d16bf9b272f1688e7367219d9b5cb9af12cda4ef9aa681ad053db as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4ddc5b072df584f13c734dbe0d8da48d72051a1ef2caacca3687fcb64f9cbd98

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
