FROM python:3.11-slim-bookworm
 
# System deps commonly needed for arcade/pyglet + Xvfb
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb xauth x11-utils \
    libgl1 \
    libglu1-mesa \
    libx11-6 libxext6 libxi6 libxrender1 libxrandr2 \
    libxcursor1 libxinerama1 libxxf86vm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*
 
WORKDIR /app
 
# Install python deps first (better build cache)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
 
# Copy the app
COPY . .
 
# Default cache dir for FastF1 (keep it in a volume if you want)
ENV FASTF1_CACHE=/app/.fastf1_cache
 
# Run with a virtual display
# You can override args at runtime: docker run ... <extra args>
ENTRYPOINT ["xvfb-run", "-a", "python", "main.py"]