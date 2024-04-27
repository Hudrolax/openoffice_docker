FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV PATH="/scripts:/py/bin:$PATH"
ENV DISPLAY=:0
ENV SAL_LOG=1
ENV SAL_USE_VCLPLUGIN=gen

COPY ./requirements.txt /tmp_req/requirements.txt
COPY ./requirements.dev.txt /tmp_req/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app

WORKDIR /app
EXPOSE 5900

ARG DEV=false
ARG VNC_PASS

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    gnupg \
    xvfb \
    x11vnc \
    fluxbox \
    xterm \
    libreoffice \
    default-jre \
    libxext6 \
    libxrender1 \
    libxtst6 \
    ca-certificates \
    fonts-freefont-ttf \
    && mkdir ~/.vnc \
    && x11vnc -storepasswd ${VNC_PASS} ~/.vnc/passwd \
    && rm -rf /var/lib/apt/lists/*

# Set up Python environment
RUN python -m venv /py \
    && /py/bin/pip install --upgrade pip \
    && /py/bin/pip install --no-cache-dir -r /tmp_req/requirements.txt \
    && if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp_req/requirements.dev.txt; fi \
    && rm -rf /tmp_req \
    && chmod -R +x /scripts

CMD ["run.sh"]
