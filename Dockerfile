# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:04217f1db802aa0b5ff8fe582a0975602d96ba0205a07e5902a5d52e10a3d71e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ba66cab5047b59445be7d413af06d68edf2d7ad26f9f4b2277f37f3229f429c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
