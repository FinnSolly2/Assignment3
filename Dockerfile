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

# Create requirements.txt with specific versions
RUN echo "Flask==2.0.1\n\
Flask-SQLAlchemy==2.5.1\n\
psycopg2-binary==2.9.1\n\
python-dotenv==0.19.0\n\
Werkzeug==2.0.3" > requirements.txt

# Install Python dependencies with correct versions first
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Clone the repository (using HTTPS for public repo)
ARG GITHUB_REPO
RUN git clone https://github.com/FinnSolly2/Assignment3.git . && \
    rm -rf .git

# Clean up unnecessary packages
RUN apt-get purge -y git gcc && \
    apt-get autoremove -y

CMD ["python", "app.py"]