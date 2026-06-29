import google.generativeai as genai

genai.configure(api_key="AIzaSyAcrSUuxksTB3Dr1_w1EXfxfU-UlSpooSo")

for m in genai.list_models():
    if "generateContent" in m.supported_generation_methods:
        print(m.name)