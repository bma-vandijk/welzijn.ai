# Welzijn AI app
This project has to do with (electronic) healthcare. 
This is an app that monitors the well-being of the patients with the help of a chatbot companion app.  The chatbot integrates questions from the medical questionnaire EQ-5D-5L into a natural conversation, with the intent that users are more willing and detailed in providing information about their well-being. It should also serve as a companion for patients who feel lonely. The user's response to each question will be mapped to a scale that quantifies the level of positivity or negativity in their response. The results of the questionnaire are then sent to caretakers, who will decide whether the patient requires additional care. 

# Features
- Speech Interaction: Engage in a natural, speech-based conversation with the chatbot.
- Questionnaire Integration: Subtly integrates a health questionnaire without user awareness.
- LLM Integration: Utilizes Groq llama3 for generating responses.
- Result Monitoring: Scaled questionnaire results for health professionals.
- Humorous Responses: Designed to be light-hearted and humorous to maintain user engagement.

# How to use
First install the backend using the readme in the eponymous folder. Then install flutter and all of its dependencies for running apps on Android, following the readme in flutter_welzijnai folder and pointers to flutter documentation etc. 
Once all of the installation is done, start the backend server in docker. Then, in vscode, select an virtual android device, and in flutter_welzijnai > lib go to main.dart and run the app/start debugging on the device.    

Note that you also need the place the pickle with weights of the reading comprehension model in backend > Models, send an email to b.m.a.van.dijk@liacs.leidenuniv.nl to get a download link.

# App design by SE 
Credits for this app go to LIACS Software engineering group '23-'24 group MKurae, vrinda-v, TimH149, Sejidz, villathalia, slaupschoeter, NikitaZelenskis, and gang-star. See for more info https://ludev.nl/.