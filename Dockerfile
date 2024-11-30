FROM python:3.9-slim as production

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the repository (using HTTPS for public repo)
ARG GITHUB_REPO
RUN git clone https://github.com/FinnSolly2/Assignment3.git . && \
    rm -rf .git

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Clean up unnecessary packages
RUN apt-get purge -y git gcc && \
    apt-get autoremove -y

CMD ["python", "app.py"]