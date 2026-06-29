from transformers import AutoImageProcessor, SiglipForImageClassification
from PIL import Image
import torch
import torch.nn.functional as F

model_name = "Ateeqq/skin-disease-prediction-exp-v1"

processor = AutoImageProcessor.from_pretrained(model_name)
model = SiglipForImageClassification.from_pretrained(model_name)

labels = model.config.id2label


# =========================
# DUAL ISSUE MAPPING
# =========================

issue_mapping = {

    "Acne and Rosacea": {"ui": "breakouts & acne", "internal": "acne"},
    "Warts Molluscum and other Viral Infections": {"ui": "skin sensitivity", "internal": "sensitive skin"},
    "Tinea Ringworm Candidiasis": {"ui": "skin irritation", "internal": "sensitive skin"},
    "Melanoma Skin Cancer Nevi and Moles": {"ui": "dark spots & uneven tone", "internal": "pigmentation"},
    "Seborrheic Keratoses": {"ui": "skin discoloration", "internal": "pigmentation"},
    "Actinic Keratosis Basal Cell Carcinoma": {"ui": "early aging signs", "internal": "aging"},
    "Eczema": {"ui": "dry & dehydrated skin", "internal": "dry skin"},
    "Atopic Dermatitis": {"ui": "very dry & damaged skin", "internal": "dry skin"},
    "Psoriasis": {"ui": "excess oil & rough texture", "internal": "oily skin"}

}


# =========================
# DESCRIPTIONS
# =========================

issue_descriptions = {

    "breakouts & acne": "Your skin shows acne and clogged pores due to excess oil.",
    "skin sensitivity": "Your skin is sensitive and may react to products or environment.",
    "skin irritation": "Your skin appears irritated and needs calming care.",
    "dark spots & uneven tone": "Your skin has pigmentation and uneven tone.",
    "skin discoloration": "Your skin shows patchy discoloration.",
    "early aging signs": "Your skin shows early aging like fine lines.",
    "dry & dehydrated skin": "Your skin lacks moisture and hydration.",
    "very dry & damaged skin": "Your skin barrier is damaged and needs repair.",
    "excess oil & rough texture": "Your skin produces excess oil and uneven texture."
}


# =========================
# SCORE
# =========================

def calculate_skin_score(issue, confidence):

    base_score = int(confidence * 100)

    penalties = {
        "acne": 20,
        "dry skin": 15,
        "oily skin": 15,
        "pigmentation": 25,
        "aging": 30,
        "sensitive skin": 10
    }

    return max(0, base_score - penalties.get(issue, 10))


def get_severity(score):

    if score >= 75:
        return "Mild"
    elif score >= 50:
        return "Moderate"
    else:
        return "Severe"


# =========================
# MAIN FUNCTION
# =========================

def predict_skin_issue(file):

    try:

        image = Image.open(file).convert("RGB")

        inputs = processor(images=image, return_tensors="pt")

        with torch.no_grad():
            logits = model(**inputs).logits

        probs = F.softmax(logits, dim=1)

        confidence, predicted = torch.max(probs, 1)

        model_issue = labels[predicted.item()]

        mapping = issue_mapping.get(model_issue, {
            "ui": "breakouts & acne",
            "internal": "acne"
        })

        ui_issue = mapping["ui"]
        internal_issue = mapping["internal"]

        confidence = round(confidence.item(), 2)

        return {
            "issue": ui_issue,
            "internal_issue": internal_issue,
            "model_prediction": model_issue,
            "description": issue_descriptions.get(ui_issue),
            "confidence": confidence,
            "consult_dermatologist": confidence < 0.60,
            "skin_score": calculate_skin_score(internal_issue, confidence),
            "severity": get_severity(calculate_skin_score(internal_issue, confidence))
        }

    except Exception as e:

        print("Error:", e)

        return {
            "issue": "unknown",
            "internal_issue": "acne",
            "model_prediction": "error",
            "description": "Unable to analyze image.",
            "confidence": 0,
            "consult_dermatologist": True,
            "skin_score": 0,
            "severity": "Unknown"
        }