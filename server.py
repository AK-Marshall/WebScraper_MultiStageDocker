from flask import Flask, jsonify
import json

WebScraper = Flask(__name__)

with open("scraped_data.json", "r", encoding="utf-8") as scrapedData:
    data = json.load(scrapedData)

@WebScraper.route("/", methods=["GET"])
def get_data():
    return jsonify(data)

if __name__ == "__main__":
    WebScraper.run(host="0.0.0.0", port=5000)
