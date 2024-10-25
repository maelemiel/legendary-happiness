import pytest
from app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_home_route(client):
    """Test la route d'accueil pour vérifier si elle est protégée par une authentification basique"""
    response = client.get('/')
    assert response.status_code == 401  # 401 Unauthorized (si la protection basique est activée)

def test_send_command(client):
    """Test l'envoi d'une commande RCON"""
    response = client.post('/send_command', json={'command': 'list'})
    assert response.status_code == 401  # Non authentifié sans Basic Auth
