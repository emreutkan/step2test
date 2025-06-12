FROM python:3.11-slim

# Install OpenSSH and Bash
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        bash \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A

# Set root password to Docker! for App Service WebSSH
RUN echo 'root:Docker!' | chpasswd

# Configure SSH daemon to listen on port 2222 and allow root/password auth
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create App Service directories (optional)
RUN mkdir -p /home /home/site/wwwroot

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files and init script
COPY init.sh ./
COPY app/ ./app/
RUN chmod +x init.sh

# Expose the HTTP and SSH ports
EXPOSE 8000 2222

# Start SSH service then Uvicorn
CMD ["./init.sh"]
