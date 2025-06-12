FROM python:3.11-slim

# Install OpenSSH and Bash
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        bash \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && ssh-keygen -A

# Set root password
RUN echo 'root:root' | chpasswd

# Allow root login and password auth
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 👇 These paths are needed for Kudu to mount its tools
RUN mkdir -p /home /home/site/wwwroot

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY init.sh .
COPY app/ ./app/
RUN chmod +x init.sh

EXPOSE 22 8000

CMD ["./init.sh"]
