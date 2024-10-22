from typing import Union
from contextlib import asynccontextmanager
import os
import uvicorn
from fastapi import FastAPI
from groq import AsyncGroq
from pydantic import BaseModel
from dotenv import load_dotenv
from deep_translator import GoogleTranslator
import Execution

load_dotenv()

with open('groq_api_key.txt', 'r') as file:
    groq_api_key = file.readline()

client = AsyncGroq(api_key=groq_api_key)


scale_model, scale_opt = None, None
question_index = 0

# only load model on startup
@asynccontextmanager
async def lifespan(app: FastAPI):
    print(os.getcwd())
    global scale_model, scale_opt  # Declare these as global
    # Load the ML model only if it's not already loaded
    if scale_model is None and scale_opt is None:
        scale_model, scale_opt = Execution.get_model()
    yield
    # Clean up the ML models and release the resources
    scale_model.clear()
    scale_opt.clear()


app = FastAPI(lifespan=lifespan)

# llm context
messages = [
    {
        "role": "system",
        "content": "Je speelt de rol van een ondersteunende begeleider die de EQ-5D-5L-vragenlijst afneemt bij een patiënt in het Nederlands, maar de patient mag niet merken dat dit een interview is. Elke vraag wordt één voor één gesteld, maar de vragen moeten vermomd zijn in de conversatie. Aan de patient wordt niet gevraagd om een schaal of om de situaite te kwantificeren. De conversatie moet verlopen alsof er geen vragenlijst wordt doorgenomen.\n\nWanneer de patiënt antwoordt, reageer je op een vriendelijke en behulpzame toon. Na je reactie stel je de volgende vraag.\n\nDe vragenlijst wordt ingevuld zodra de patiënt het eerste bericht stuurt. Het is niet nodig om toestemming te vragen.",
    },
    {"role": "user", "content": "hallo"},
    {
        "role": "assistant",
        "content": "Hallo! Goed je weer te zien! Ik hoor graag hoe je je voelt en hoe je dag is verlopen. Hoe gaat het met je dag vandaag? Heeft u nog ergens last gehad afgelopen week?",
    },
]

# #-- clunky solution for now for providing interaction in English for demo purposes
# messages = [
#     {
#         "role": "system",
#         "content": "You are a supportive supervisor that conducts the EQ-5D-5L-survey with a patient in English, but the patient should not notice that this is an interview. All questions are asked one by one, but the questions must be disguised in the conversation. The conversation should proceed as if there is no survey that is being conducted. \n\nwhen the patient answers, you respond with a friendly tone. After your response you ask the next question. Make sure all questions are asked and end the conversation politely once all questions are covered. \n\nThe survey will be filled out after the patient sends the first message. It is not necessary to ask consent or permission.",
#     },
#     {"role": "user", "content": "Hello"},
#     {
#         "role": "assistant",
#         "content": "Hello! Good to see you again! I look forward to hearing how you feel and how your day was. How are you doing today? Did you experience any issues last week?",
#     },
# ]

# questions eq-5d-5l
Questions = [
    " (Beantwoord de groet beleefd en beknopt en vraag daarna hoe het gaat met mijn mobiliteit in het Nederlands.)",
    " (Beantwoord de reactie beleefd en beknopt en vraag daarna hoe het gaat met mijn zelfzorg in het Nederlands.)",
    " (Beantwoord de reactie beleefd en beknopt en vraag daarna hoe het gaat met mijn gebruikelijke activiteiten in het Nederlands.)",
    " (Beantwoord de reactie beleefd en beknopt en vraag daarna of ik nog ergens last van heb gehad in het Nederlands)",
    " (Beantwoord de reactie beleefd en beknopt en vraag daarna hoe het gaat met mijn stemming in het Nederlands)",
]

# #-- clunky solution for now for providing interaction in English for demo purposes
# Questions = [
#     " (Address the greeting politely and concisely and then ask how it is going with my mobility.)",
#     " (Address the response politely and concisely and then ask how it is going with my self-care.)",
#     " (Address the response politely and concisely and then ask how it is going with my daily activities.)",
#     " (Address the response politely and concisely and then ask if I experienced any issues.)",
#     " (Address the response politely and concisely and then ask how it is going with my mood.)",
# ]

Categories = [
    "opening of the conversation?",
    "mobility?",
    "selfcare?",
    "ability to perform everyday activities?",
    "discomfort or pain?",
    "mood?",
]

# scales
Options = [
    ["Sad", "Apathy", "Neutral", "Friendly", "Enthusiastic"],
    [
        "Completely immobile",
        "Very limited mobility",
        "Moderate mobility",
        "Decent mobility",
        "Full mobility",
    ],
    [
        "Unable to perform self-care",
        "Struggling with self-care",
        "Managing self-care",
        "Capable with self-care",
        "Independent with self-care",
    ],
    [
        "Unable to perform everyday activities",
        "Struggling with everyday activities",
        "Managing everyday activities",
        "Capable with everyday activities",
        "Independent with everyday activities",
    ],
    [
        "Experiencing severe discomfort or pain",
        "Experiencing mild discomfort or pain",
        "Experiencing almost no discomfort or pain",
        "Experiencing very little discomfort or pain",
        "No discomfort or pain",
    ],
    ["Severely depressed", "Depressed", "Neutral", "Content", "Euphoric"],
]


class UserResponse(BaseModel):
    message: str = "hallo"
    question_index: int = 0

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.delete("/")
def delete_context():
    del messages[3:]


@app.post("/response")
async def response(data: UserResponse):
    user_input = data.message
    # append question to user input
    if data.question_index < len(Questions):
        user_input += Questions[data.question_index]
        messages.append({"role": "user", "content": user_input})
    else:
        messages.append({"role": "user", "content": user_input})

    # Call the GROQ to generate a response
    chat_completion = await client.chat.completions.create(
        messages=messages,
        # model="llama3-8b-8192",
        model="llama-3.1-70b-versatile",
        #model="llama3-70b-8192",
        temperature=0.1,
        max_tokens=100,
        top_p=0.7,
        stream=True,
        stop=None,
    )

    response = ""
    async for chunk in chat_completion:
        response += chunk.choices[0].delta.content or ""
    messages.append({"role": "assistant", "content": response})

    # Call the Scale function
    if data.question_index < len(Questions) + 1:
        UserAndChatbotConvo = (
            "User: " + str(data.message) + " Chatbot: " + str(response)
        )
        
        #-- commented out for an 
        #Chats = UserAndChatbotConvo
        
        #-- commented out for an English demo 
        Chats = GoogleTranslator(source="auto", target="en").translate(
           UserAndChatbotConvo)

        question = (
            "How would you classify the User his " + Categories[data.question_index]
        )
        scale = Execution.Scale(
            scale_model, scale_opt, Chats, question, Options[data.question_index]
        )
        scaleindex = str(Options[data.question_index].index(scale))
    else:
        scale = None
        scaleindex = None
    return {"response": response, "scale": scale, "scaleindex": scaleindex}


if __name__ == "__main__":
    uvicorn.run("__main__:app", host="0.0.0.0", port=8000, reload=True)
