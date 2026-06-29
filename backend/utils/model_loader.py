import torch
import torchvision.models as models

device = torch.device("cpu")

classes = [
    "acne",
    "pigmentation",
    "dark circles",
    "dry skin",
    "oily skin",
    "wrinkles"
]

def load_model():

    # pretrained efficientnet
    model = models.efficientnet_b0(weights="DEFAULT")

    model.classifier[1] = torch.nn.Linear(1280, len(classes))

    model.eval()

    return model, classes