const puppeteer = require("puppeteer");
const fs = require("fs");

(async () => {
  const scraped_url = process.env.SCRAPE_URL; 
  
  const browser = await puppeteer.launch({ 
    headless: true,
    executablePath: '/usr/bin/chromium',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  
  const page = await browser.newPage();
  await page.goto(scraped_url, { waitUntil: "networkidle2" });

  const data = await page.evaluate(() => {
    return {
      title: document.title,
      firstHeading: document.querySelector("h1") ? document.querySelector("h1").innerText : null,
      secondHeading: document.querySelector("h2") ? document.querySelector("h2").innerText : null
    };
  });

  fs.writeFileSync("scraped_data.json", JSON.stringify(data, null, 2));
  
  await browser.close();
  
})();
