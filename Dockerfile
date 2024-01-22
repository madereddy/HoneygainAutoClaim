# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2c8947a0bd8211e7cc560e2a4f38c3d7df67713e3e2635e6afba588b010a2c4a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:912c717c86f983a0029960016262c2443e44b1b50ca59fdc49228a49ab4173f8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
