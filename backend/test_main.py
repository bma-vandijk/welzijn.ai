from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
from main import app

client = TestClient(app)


def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"Hello": "World"}


def test_delete_context():
    response = client.delete("/")
    assert response.status_code == 200


# mocking the Scale function
@patch("main.Execution.Scale")
def test_response(mock_scale):
    mock_scale.return_value = "Neutral"
    data = {"message": "hello", "question_index": 0}
    response = client.post("/response", json=data)
    assert response.status_code == 200
    assert "response" in response.json()
    assert "scale" in response.json()
    assert "scaleindex" in response.json()


# when index is above the number of questions
def test_response_above():
    data = {"message": "hello", "question_index": 6}
    response = client.post("/response", json=data)
    assert response.status_code == 200
    assert "response" in response.json()
    assert response.json()["scale"] is None
    assert response.json()["scaleindex"] is None
