# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:26ed3bc11419b81a1d787e9815024e294adc5c5749ae3d9d944cf93151a93d12 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:26af703291a0edd92560df0ddfaaa6deb07be1885131991edd195d9d6f5e1885

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
