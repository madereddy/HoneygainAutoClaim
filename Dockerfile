# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3a95ebbec80663509e75b71e3b6586a5b85a911f2a77cc6bcd5d9553c81050b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c7c2a5c9dda407966db7b767aca6f06413941176428eb162b5a9499940407786

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
