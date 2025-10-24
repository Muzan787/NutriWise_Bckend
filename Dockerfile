# 1. Start with a official Node.js 18 image
FROM node:18-slim

# 2. Install Python, pip, and venv tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 3. Set up the Python environment (FIXED SECTION)
# Create a virtual environment in /opt/venv
RUN python3 -m venv /opt/venv
# Add the venv's bin directory to the system's PATH
# This makes `python` and `pip` use the venv's versions
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install into the venv (This layer will be cached)
COPY requirements.txt .
RUN pip install -r requirements.txt

# 4. Set up the Node.js environment
WORKDIR /app
# Copy package files first to leverage caching
COPY package.json package-lock.json ./
RUN npm install --production

# 5. Copy the rest of your application code
COPY . .

# 6. Define the start command
# This tells Railway to run "node server.js"
CMD ["node", "server.js"]