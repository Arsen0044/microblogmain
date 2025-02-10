FROM python:slim

# Update and install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libpq-dev \
    gcc \
    libffi-dev \
    libssl-dev \
    make

# Upgrade pip and setuptools to the latest versions
RUN pip install --upgrade pip setuptools wheel

# Install greenlet from binary wheels (if available)
RUN pip install --only-binary :all: greenlet

# Copy requirements and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Install additional packages (gunicorn, pymysql, cryptography)
RUN pip install gunicorn pymysql cryptography

# Copy application files
COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

# Make boot.sh executable
RUN chmod a+x boot.sh

# Set environment variable
ENV FLASK_APP microblog.py

# Compile translations
RUN flask translate compile

# Expose port 5000
EXPOSE 5000

# Start application
ENTRYPOINT ["./boot.sh"]
