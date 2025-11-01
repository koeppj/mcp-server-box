# Python 3.12, small, with Debian Bookworm base
FROM python:3.13-slim

# System deps for TLS and timezones
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG UID=10001
ARG GID=10001
RUN groupadd -g ${GID} app && useradd -u ${UID} -g ${GID} -m -s /usr/sbin/nologin app
WORKDIR /app

# App code
# Ensure your script filename matches here
COPY src/ /app/
COPY requirements.txt requirements.txt

# Install Python deps
# If you have a requirements.txt, COPY it instead and RUN pip install -r requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

USER app

# Required at runtime:
# - BOX_CLIENT_ID=your_client_id
# - BOX_CLIENT_SECRET=your_client_secret
# - BOX_SUBJECT_TYPE = user # or enterprise
# - BOX_SUBJECT_ID = your user id or enterprise id
ENTRYPOINT ["python", "/app/mcp_server_box.py", "--box-auth", "ccg","--transport", "streamable-http"]
