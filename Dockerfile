# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:80e9bf37c59c9ac927491f4933e4d5c414028a42a5ba4240f8a5af01136b35df as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4cd9986c4e8c6c5f091a46f38f19b212e0f46a21e8e6e540596f266a123781c2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
