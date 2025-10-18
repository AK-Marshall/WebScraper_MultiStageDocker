# STAGE 1 - Node.Js + Puppeteer for Webscraper to create Scraped_Data.json
FROM node:18-slim AS scraper

RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libnss3 \
    libxss1 \
    libasound2 \
    libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY scrape.js ./


ARG SCRAPE_URL=https://example.com
ENV SCRAPE_URL=${SCRAPE_URL}


RUN node scrape.js 


# STAGE 2 Python + Flask Module for Webserver to Display Scraper_Data.json on Port : 5000
FROM python:3.10-slim AS final
WORKDIR /app


COPY --from=scraper /app/scraped_data.json /app/

COPY server.py requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "server.py"]

