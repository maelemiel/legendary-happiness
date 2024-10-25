// Gestion des logs via Socket.IO
document.addEventListener("DOMContentLoaded", function () {
    fetch('config.json')
    .then(response => response.json())
    .then(config => {
        const socket = io.connect(config.server_ip);

        // Réception des logs en temps réel
        socket.on('server_logs', function (data) {
            appendLog(data.data);
        });

        // Demande initiale pour les logs
        socket.emit('get_logs');
    });
});

// Envoi de commandes rapides
function sendQuickCommand(command) {
    sendCommand(command);
}

// Envoi de commandes
function sendCommand(command = null) {
    if (!command) {
        command = document.getElementById("command").value;
    }

    if (!command) {
        displayError("Veuillez entrer une commande !");
        return;
    }

    fetch('/send_command', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ command: command })
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            displayError(`Erreur: ${data.error}`);
        } else {
            const formattedResponse = formatMinecraftCommands(data.response);
            displayResponse(formattedResponse);
        }
    })
    .catch(error => {
        displayError(`Erreur: ${error}`);
    });
}

// Formater les commandes Minecraft
function formatMinecraftCommands(commands) {
    const commandList = commands.split('/');
    return commandList.map(command => {
        if (command.includes('(') && command.includes(')')) {
            const mainCommand = command.split('(')[0];
            const options = command.match(/\((.*?)\)/)[1].split('|');
            const formattedOptions = options.map(option => `<li>${option}</li>`).join('');
            return `<div><strong>${mainCommand.trim()}</strong><ul>${formattedOptions}</ul></div>`;
        } else {
            return `<div><strong>${command.trim()}</strong></div>`;
        }
    }).join('');
}

// Affichage du résultat de la commande
function displayResponse(response) {
    document.getElementById("response").innerHTML = `<strong>Réponse:</strong><br>${response}`;
}

// Affichage d'une erreur
function displayError(message) {
    document.getElementById("response").innerHTML = `<strong>Erreur:</strong> ${message}`;
}

// Ajouter des logs
function appendLog(log) {
    const logsContainer = document.getElementById('logs');
    logsContainer.innerHTML += log + '<br>';
    logsContainer.scrollTop = logsContainer.scrollHeight;
}
