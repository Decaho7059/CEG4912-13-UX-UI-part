from flask import Flask, jsonify, request

app = Flask(__name__)

# Endpoint pour vérifier l'état du Raspberry Pi
@app.route('/status', methods=['GET'])
def get_status():
    return jsonify({"status": "Raspberry Pi is running!"}), 200

# Endpoint pour effectuer une action
@app.route('/action', methods=['POST'])
def perform_action():
    data = request.json
    action = data.get('action', '')

    # Simuler une action
    if action == "ON":
        # Simuler une activation de GPIO ou autre fonctionnalité
        return jsonify({"message": "Device turned ON"}), 200
    elif action == "OFF":
        # Simuler une désactivation de GPIO ou autre fonctionnalité
        return jsonify({"message": "Device turned OFF"}), 200
    else:
        return jsonify({"error": "Invalid action"}), 400

# Endpoint pour récupérer des données simulées
@app.route('/data', methods=['GET'])
def get_data():
    simulated_data = {
        "temperature": 22.5,
        "humidity": 45,
        "status": "Operational"
    }
    return jsonify(simulated_data), 200

if __name__ == '__main__':
    # Lancer le serveur sur toutes les interfaces réseau locales
    app.run(host='0.0.0.0', port=5000)
