import os
import json
import logging
from flask import Flask, jsonify

# Configure logging
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] [INFO] %(message)s')
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route('/')
def index():
    """
    Root endpoint. Returns a welcome message and the current version.
    Proof of Rolling Updates.
    """
    version = os.environ.get('APP_VERSION', '1.0.0')
    logger.info(f"Request received at / (Version: {version})")
    return jsonify({
        "message": "SaaS Platform v2 - API is Running",
        "version": version
    })

@app.route('/health')
def health():
    """
    Health check endpoint.
    Proof of Liveness/Readiness Probes.
    """
    return jsonify({"status": "healthy"}), 200

@app.route('/config')
def config():
    """
    Configuration dump endpoint.
    Proof of ConfigMap/Secret injection.
    """
    # We dump all environment variables to verify injection
    # In a real scenario, we might want to filter sensitive keys
    env_vars = dict(os.environ)
    return jsonify(env_vars)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    logger.info(f"Starting application on port {port}...")
    app.run(host='0.0.0.0', port=port)