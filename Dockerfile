# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d0556b1f380995084c710201c5ec24947d5e0479c1a99fbd36815cf62652d279 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4ada7882a19aa2f78907715be19c702294d5318b196e3ab45987b900f4ef6dd2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
