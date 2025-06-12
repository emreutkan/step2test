# syntax=docker/dockerfile:1

FROM python:3.11-slim

# 1. Install OpenSSH Server and generate host keys
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && ssh-keygen -A

# 2. Set root password (change "root" below to a stronger password or use build args)
RUN echo 'root:root' | chpasswd

# 3. Enable password authentication and root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 4. Set work directory
WORKDIR /app

# 5. Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy application code and init script
COPY init.sh .
COPY app/ ./app/
RUN chmod +x init.sh

# 7. Expose SSH and app ports
EXPOSE 22 8000

# 8. Start SSHD and Uvicorn via init script
CMD ["./init.sh"]
