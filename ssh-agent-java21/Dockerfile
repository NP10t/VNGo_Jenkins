# Sử dụng image cơ sở có Java 21
FROM openjdk:21-jdk-slim AS base

# Thiết lập các biến môi trường
ENV JAVA_HOME=/usr/local/openjdk-21 \
    PATH=$JAVA_HOME/bin:$PATH \
    SSH_USER=jenkins-agent \
    SSH_PASSWORD=jenkins123

# Cài đặt các gói cần thiết, bao gồm SSH server
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình SSH
RUN mkdir /var/run/sshd \
    && echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Tạo user cho Jenkins agent
RUN useradd -m -s /bin/bash ${SSH_USER} \
    && echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# Tạo thư mục .ssh cho SSH key
RUN mkdir -p /home/${SSH_USER}/.ssh \
    && chown ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh \
    && chmod 700 /home/${SSH_USER}/.ssh

# Copy script khởi động
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 22 cho SSH
EXPOSE 22

# Chạy script khởi động
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]