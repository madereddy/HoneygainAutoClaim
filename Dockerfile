# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:111c11048cd1ec038291aa47670277e7a377c94a8471603783758d2cf66e7fff as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f3c4aadce2bd015ec36a777eface9389cb5cf8a0656bd85d7a9b8ce1cfbfac1e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
