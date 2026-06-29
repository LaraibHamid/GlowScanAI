from flask import Blueprint, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore

history_bp = Blueprint("history", __name__)

# ==========================
# INITIALIZE FIREBASE
# ==========================

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()

# ==========================
# GET USER SCAN HISTORY
# ==========================

@history_bp.route("/history", methods=["GET"])
def get_history():

    uid = request.args.get("uid")

    if not uid:
        return jsonify([])

    try:

        scans = db.collection("users") \
            .document(uid) \
            .collection("skin_logs") \
            .order_by("date", direction=firestore.Query.DESCENDING) \
            .stream()

        history_data = []

        for doc in scans:
            item = doc.to_dict()
            item["id"] = doc.id
            history_data.append(item)

        return jsonify(history_data)

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500
