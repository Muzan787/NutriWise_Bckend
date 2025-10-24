# 1. Start with a official Node.js 18 image
FROM node:18-slim

# 2. Install Python, pip, and other system tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 3. Set up the Python environment (This layer will be cached)
# Copy requirements first to leverage caching
COPY requirements.txt .
RUN pip3 install -r requirements.txt

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