from flask import Blueprint, request, jsonify
from services.gemini_service import ask_gemini

chat_bp = Blueprint("chat", __name__)

@chat_bp.route("/chat", methods=["POST"])
def chat():

    data = request.json
    message = data.get("message")

    reply = ask_gemini(message)

    return jsonify({
        "reply": reply
    })