from flask import Blueprint, request, jsonify
from models.skin_model import predict_skin_issue
from recommendation.recommendation_engine import generate_routine
from datetime import datetime

import firebase_admin
from firebase_admin import credentials, firestore

analyze_bp = Blueprint("analyze", __name__)

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()


@analyze_bp.route("/analyze", methods=["POST"])
def analyze():

    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files["image"]
    uid = request.form.get("uid")

    result = predict_skin_issue(file)

    #  FIX: use internal issue for products
    internal_issue = result["internal_issue"]

    recommendations = generate_routine(internal_issue)

    response = {
        "issue": result["issue"],  # UI
        "description": result["description"],
        "confidence": result["confidence"],
        "consult_dermatologist": result["consult_dermatologist"],
        "skin_score": result["skin_score"],
        "severity": result["severity"],
        "recommendations": recommendations,
        "date": datetime.now().strftime("%d %B %Y")
    }

    if uid:
        db.collection("users") \
          .document(uid) \
          .collection("skin_logs") \
          .add(response)

    return jsonify(response)