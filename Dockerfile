# 1. Start with a official Node.js 18 image
FROM node:18-slim

# 2. Install Python, pip, venv tools, git, AND curl
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    --no-install-recommends && \
    # Clean up apt cache
    rm -rf /var/lib/apt/lists/*

# 3. Set up the Python environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install into the venv, then clean up pip cache
COPY requirements.txt .
RUN pip install -r requirements.txt && \
    # Clean up pip cache
    rm -rf /root/.cache/pip

# 4. Set up the Node.js environment
WORKDIR /app
COPY package.json package-lock.json ./
# Run install, which also runs postinstall, then clean up npm cache
RUN npm install --omit=dev && \
    # Clean up npm cache
    npm cache clean --force && \
    rm -rf /root/.npm/_logs

# 5. Copy the rest of your application code (now very fast due to .dockerignore)
COPY . .

# 6. Define the start command
CMD ["node", "server.js"]