FROM python:3.9-slim as production

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Create requirements.txt with specific versions
RUN echo "Flask==2.0.1\n\
Flask-SQLAlchemy==2.5.1\n\
SQLAlchemy==1.4.23\n\
psycopg2-binary==2.9.1\n\
python-dotenv==0.19.0\n\
Werkzeug==2.0.3" > requirements.txt

# Install Python dependencies with correct versions first
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create a temporary directory for cloning
WORKDIR /tmp/repo

# Clone the repository
ARG GITHUB_REPO
RUN git clone https://github.com/FinnSolly2/Assignment3.git . && \
    cp -r * /app/ && \
    cd /app

# Clean up unnecessary packages
RUN apt-get purge -y git gcc && \
    apt-get autoremove -y

# Set back to app directory
WORKDIR /app

# Make init.sh executable
RUN chmod +x init.sh

CMD ["./init.sh"]