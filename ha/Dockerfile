# Use the official Home Assistant image as the base
FROM ghcr.io/home-assistant/home-assistant:stable

# Switch to root to install additional packages
USER root

# Install additional packages
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    nano \
    htop \
    iputils \
    net-tools

# Install pip and some useful Python packages
RUN pip3 install --no-cache-dir \
    paho-mqtt \
    requests \
    pillow \
    psutil

# Create a dedicated non-login user for Home Assistant
RUN adduser -D -u 1000 homeassistant

# Create a directory for custom components
RUN mkdir -p /config/custom_components

# Copy any custom files or scripts
COPY ./custom_scripts /config/custom_scripts

# Set up a custom entry point script
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set ownership of the config directory
RUN chown -R homeassistant:homeassistant /config

# Switch to the homeassistant user
USER homeassistant

# Set the working directory
WORKDIR /config

# Set the entry point
ENTRYPOINT ["/entrypoint.sh"]

# Set the default command
CMD ["hass", "-c", "/config"]