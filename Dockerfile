# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:26b02474f34f7f7551fa3d061b61284aad5bd9f1e7f7c34af88c0460439a0b23 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2ada7aa3b53df8980a65429f2a94865ed29b5d454d36ff78bb89b850c73d54ba

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
