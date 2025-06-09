FROM python:3.9-slim

# Install bash, SSH server, and build tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash openssh-server build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd

# Set root password and enable root login (override in production)
RUN echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /app
# Copy dependencies list and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and init script
COPY . /app
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Expose HTTP and SSH ports
EXPOSE 8000 22

# Launch SSH and FastAPI via init script
CMD ["/usr/local/bin/init.sh"]