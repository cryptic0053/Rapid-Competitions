FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && apt-get clean

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

# Run collectstatic, makemigrations, migrate, then gunicorn
CMD ["bash", "-c", "python3 manage.py collectstatic --noinput && python3 manage.py makemigrations && python3 manage.py migrate && gunicorn rapid.wsgi:application --bind 0.0.0.0:8000"]
