# Use Ubuntu base image
FROM ubuntu:latest

# Set a working directory
WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends libstdc++6 openssl wget ca-certificates tar python3 python3.12-venv && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python dependencies in the virtual environment
RUN pip install requests beautifulsoup4

# Ensure scripts are copied correctly
COPY download_script.py entry_script.sh /app/

# Create necessary directory
RUN mkdir -p /app/GTAC-Server

# Change script permissions and run
RUN chmod +x /app/entry_script.sh
RUN /app/entry_script.sh


# Clean up unnecessary files
RUN rm -rf /var/cache/apk/* /tmp/* /app/venv

# Expose server port (adjust if different ports are required)
EXPOSE 22000

WORKDIR /app/GTAC-Server

# Set default command, adjust the executable as needed
CMD ["/app/GTAC-Server/Server"]
