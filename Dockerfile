# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1206c7116ee324016feba159168b46d4b38d160f0950d760cdeb94f5274c3b9d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:36fa008a26430f212a459a36493a87b8ea2418d1eed810ac64302e05d579b791

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
