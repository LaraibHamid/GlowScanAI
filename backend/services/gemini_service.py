import google.generativeai as genai

genai.configure(api_key="AIzaSyDZYCZ4PHuEIuddSt7zk557q364Ve0FFpU")

def ask_gemini(prompt):
    try:
        model = genai.GenerativeModel("gemini-2.5-flash")

        response = model.generate_content(prompt)

        return response.text

    except Exception as e:
        return f"AI Error: {str(e)}"