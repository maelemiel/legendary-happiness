import subprocess
import pytest

def test_rcon_command():
    """Teste l'exécution de la commande RCON"""
    result = subprocess.run(
        ['mcrcon', '-H', '127.0.0.1', '-P', '25575', '-p', 'votre_mot_de_passe_rcon_sécurisé', 'list'],
        capture_output=True, text=True
    )
    assert result.returncode == 0
    assert "players online" in result.stdout
