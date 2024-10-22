# Backend
This folder contains the backend of our app. Start up this server before you use the flutter application.

# Quickstart

1. **Clone this project**

    ```bash
    git clone [project_url]
    ```

2. **Create virtual environment:**

    ```bash
    python3 -m venv ./venv
    ```

    ```cmd
    python -m venv myvenv
    ```

3. **Activate environment:**

    ```bash
    source ./venv/bin/activate
    ```

    ```cmd
    myvenv/Scripts/activate
    ```

4. **Install dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

5. **Copy .env-sample in a file called .env, and add your groq API.** Get it [here](https://console.groq.com/playground)

6. **Put Runda Weights in Models map**

7. **Run app** 

    ```bash
   docker compose up
    ```

    or

    ```bash
    uvicorn main:app --reload --port=8000 --host=0.0.0.0
    ```
