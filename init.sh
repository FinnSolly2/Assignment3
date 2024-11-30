#!/bin/bash
echo "Waiting for database..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "Database is ready!"
python init_db.py
python app.py

# Make executable
chmod +x init.sh 