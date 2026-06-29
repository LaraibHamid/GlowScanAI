from flask import Flask
from flask_cors import CORS
from routes.analyze_route import analyze_bp
from routes.chat_route import chat_bp
from routes.history_route import history_bp

app = Flask(__name__)
CORS(app)

# ==========================
# REGISTER ROUTES
# ==========================

app.register_blueprint(analyze_bp)
app.register_blueprint(chat_bp)
app.register_blueprint(history_bp)

# ==========================
# HOME ROUTE
# ==========================

@app.route("/")
def home():
    return {"message": "GlowScanAI Backend Running"}

# ==========================
# RUN SERVER
# ==========================

if __name__ == "__main__":
    print("Starting GlowScanAI Backend...")
    app.run(host="0.0.0.0", port=5000, debug=True)

