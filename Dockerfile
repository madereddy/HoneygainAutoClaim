# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:245ebbae834ab2c1cfeb57d3255a6a26e70f0581b6c01d70c78303a68eccc89f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b0feb5ef76e7306fe54d6a472053a3dc929e19a5f7d5b10dfd606d2f7104029d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
