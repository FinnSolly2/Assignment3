FROM python:3.9 as development

# Install system dependencies including PostgreSQL client
RUN apt-get update && \
    apt-get install -y \
    git \
    openssh-client \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    && mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keyscan github.com > /root/.ssh/known_hosts

# Add SSH key during build
ARG SSH_PRIVATE_KEY
ARG GITHUB_REPO
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

# Clone repository
WORKDIR /app
RUN git clone ${GITHUB_REPO} .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

FROM python:3.9-slim as production

# Install system dependencies including PostgreSQL client
RUN apt-get update && \
    apt-get install -y \
    git \
    openssh-client \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    && mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keyscan github.com > /root/.ssh/known_hosts \
    && rm -rf /var/lib/apt/lists/*

# Add SSH key during build
ARG SSH_PRIVATE_KEY
ARG GITHUB_REPO
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

# Clone repository
WORKDIR /app
RUN git clone ${GITHUB_REPO} .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Clean up SSH key and unnecessary packages
RUN rm -rf /root/.ssh/ && \
    apt-get purge -y git openssh-client gcc && \
    apt-get autoremove -y

CMD ["python", "app.py"]
