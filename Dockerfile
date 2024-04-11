# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:40c00b1ba01afc303c8b54bc381a0cbeeae0882367410a8371f4d02823d9f88a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f8e572ab2e1f84c9210977cffe6ec16b14f783ae29ba51a606ca23bd9acf28ba

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
