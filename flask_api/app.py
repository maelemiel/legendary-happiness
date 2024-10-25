from flask import Flask, request, jsonify, render_template
import subprocess
import os
import re
from flask_basicauth import BasicAuth
from flask_socketio import SocketIO, emit

app = Flask(__name__, static_folder='static', template_folder='templates')
socketio = SocketIO(app, cors_allowed_origins="*")  # Ajoutez cors_allowed_origins="*" pour éviter les erreurs de CORS.

# Configuration RCON
RCON_HOST = os.getenv("RCON_HOST", "127.0.0.1")
RCON_PORT = os.getenv("RCON_PORT", "25575")
RCON_PASSWORD = os.getenv("RCON_PASSWORD", "")

# Configuration de l'authentification basique
app.config['BASIC_AUTH_USERNAME'] = os.getenv("BASIC_AUTH_USERNAME", "admin")
app.config['BASIC_AUTH_PASSWORD'] = os.getenv("BASIC_AUTH_PASSWORD", "password")
app.config['BASIC_AUTH_FORCE'] = True

basic_auth = BasicAuth(app)

# ? Functions



# ? Routes

@app.route('/')
@basic_auth.required
def home():
    return render_template('index.html')

@app.route('/send_command', methods=['POST'])

# Route pour obtenir la liste des joueurs connectés
@app.route('/connected_players', methods=['GET'])
def connected_players():
    try:
        result = subprocess.run(
            ['mcrcon', '-H', RCON_HOST, '-P', RCON_PORT, '-p', RCON_PASSWORD, 'list'],
            capture_output=True, text=True
        )

        if result.returncode != 0:
            return jsonify({"error": "Erreur lors de la récupération de la liste des joueurs.", "details": result.stderr}), 500

        # Supprimer les séquences ANSI et formater la sortie
        output = re.sub(r'\x1B\[[0-?]*[ -/]*[@-~]', '', result.stdout)
        players = output.split("players online: ")[-1].split(", ") if "players online:" in output else []

        return jsonify({"players": players})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@basic_auth.required
def send_command():
    try:
        command = request.json.get('command')
        if not command:
            return jsonify({"error": "Veuillez fournir une commande."}), 400

        result = subprocess.run(
            ['mcrcon', '-H', RCON_HOST, '-P', RCON_PORT, '-p', RCON_PASSWORD, command],
            capture_output=True, text=True
        )

        if result.returncode != 0:
            return jsonify({"error": "Erreur lors de l'envoi de la commande.", "details": result.stderr}), 500

        # Supprimer les séquences ANSI (comme \u001b[0m)
        clean_output = re.sub(r'\x1B\[[0-?]*[ -/]*[@-~]', '', result.stdout)

        return jsonify({"response": clean_output.strip()})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ? SocketIO

# Fonction pour lire les logs du serveur et les envoyer au client en temps réel
@socketio.on('connect')
def handle_connect():
    emit('server_message', {'data': 'Connexion établie !'})

@socketio.on('get_logs')
def handle_get_logs():
    try:
        # Lire les messages du serveur avec RCON
        result = subprocess.run(
            ['mcrcon', '-H', RCON_HOST, '-P', RCON_PORT, '-p', RCON_PASSWORD, 'list'],
            capture_output=True, text=True
        )

        # Nettoyer la sortie et envoyer les logs au client
        if result.returncode == 0:
            clean_output = re.sub(r'\x1B\[[0-?]*[ -/]*[@-~]', '', result.stdout)
            emit('server_logs', {'data': clean_output.strip()})
        else:
            emit('server_logs', {'data': f'Erreur lors de la récupération des logs: {result.stderr}'})
    except Exception as e:
        emit('server_logs', {'data': f'Erreur: {str(e)}'})

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000)