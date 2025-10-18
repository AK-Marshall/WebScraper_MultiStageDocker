# WEBSCRAPER - Multi-Stage Docker Build ( Node.Js + Python + Puppeteer + Flask )

This project demonstrates how to build a multi-stage Docker application that uses Node.js and Puppeteer to scrape a website and Python Flask to host the scraped content. The final container exposes an HTTP endpoint to view the extracted data in JSON format.

Project Objectives
- *Uses Node.js with Puppeteer and Chromium to scrape a user-specified URL.*
- *Uses Python (Flask) to host the scraped data.*
- *Keeps the final runtime image minimal while showing containerization best practices.*


## Working

**scraper.js**

This JS file uses Node.Js with Puppeteer Library to perform the scrape from user-specified URL.

Ensure that all dependencies are installed and npm is initialized using `npm init` in the terminal.

**Note:** Always ensure that all the required files are in a single folder to avoid errors during Docker build or runtime.

**Program Workflow Explained**

- Import the modules **puppeteer** and **fs**.
- Variable **scraped_url** is to get the user-specified URL from build phase; also environment variable is default set to `https://example.com` to avoid errors.
- Puppeteer is configured to use the Chromium binary located with `--no-sandbox` and `--disable-setuid-sandbox` flags to ensure compatibility in headless mode.
- A new browser tab opens and navigates to user-specified URL using `page.goto()`. The `waituntil` option ensures that the script waits until the page has loaded before extracting data.
- The `page.evaluate()` function is used to extract the required details — currently, it extracts **Title**, **First**, and **Second heading** from the URL. It can be modified according to the requirements.
- `fs.writeFileSync()` method is used to write the data into the **scraped_data.json** file, and `JSON.stringify()` converts the data input to JSON format.

**server.py**

This Python file uses **Flask Library** to create a web server that reads **scraped_data.json** file and serves the JSON response when accessed through  
http://localhost:5000/


## Environment Variables

This Environment Variable is used to take the user-specified URL. By default it runs with "https://example.com"

| Variable | Description | Default |
|-----------|--------------|----------|
| `SCRAPE_URL` | The URL to scrape using custom user input | `https://example.com` |

## Dockerfile Overview

### Stage 1 – Scraper (Node.js + Puppeteer)
- **Base image:** `node:18-slim`
- Installs **Chromium** and **Puppeteer**
- Runs `scrape.js` using the environment variable `SCRAPE_URL`
- Produces the output file `scraped_data.json`

### Stage 2 – Server (Python + Flask)
- **Base image:** `python:3.10-slim`
- Copies `scraped_data.json` from the first stage
- Installs **Flask** from `requirements.txt`
- Runs `server.py`, which serves the JSON at `http://localhost:5000`

## Docker Build Instructions

Build the Docker image with the URL to scrape as a build argument:

`docker build -t webscraper --build-arg SCRAPE_URL=https://google.com .`

This will:

Install Node.js + Chromium + Puppeteer

Scrape data from the provided URL

Create `scraped_data.json`

Build the final Python Flask image
## Docker Run Instructions

Once the image has been built successfully, you can run the container with:

`docker run -d -p 5000:5000 webscraper`

Also you can check if the container is running with:

`docker ps`
## Testing Instructions

After running the container, visit:

http://localhost:5000

If the JSON output appears correctly, the application has built and run successfully.

## Example Output

An example when SCRAP_URL = https://google.com

```json
{
  "title": "Google",
  "firstHeading": "null",
  "secondHeading": "null" 
}
```
