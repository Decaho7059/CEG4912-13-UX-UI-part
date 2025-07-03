# 📫 SENDMAS - Smart Mailbox Application

SENDMAS est une application mobile multiplateforme développée dans le cadre d’un **projet de fin d’études**,
conçue pour moderniser et sécuriser la gestion de courrier grâce à une solution numérique complète, connectée et intelligente.

---

## ✨ Présentation

SENDMAS (acronyme formé à partir des initiales des membres de l'équipe) est une solution intuitive pour :
- le **suivi en temps réel** des lettres,
- la **gestion intelligente de boîtes aux lettres physiques**,
- et l’administration **multi-utilisateur**.

Cette application met l’accent sur **l’expérience utilisateur (UX)** et une interface épurée (**UI**),
tout en intégrant une architecture backend robuste et des interactions matérielles via Raspberry Pi.

---

## 📱 Fonctionnalités principales

### 👩‍💼 Partie Administrateur :
- Connexion sécurisée
- Interface d’accueil personnalisée
- Gestion de profils utilisateurs (affichage, édition, suppression)
- Accès à toutes les données utilisateur via MongoDB

### 👤 Partie Utilisateur :
- Inscription et connexion
- Accueil personnalisé avec logo et message de bienvenue
- Suivi des courriers sur carte interactive (Google Maps)
- Visualisation et édition du profil personnel
- Déconnexion / Quitter l’application
- Section « À propos »

### 🛠️ Interactions Matérielles :
- Ouverture de boîtes intelligentes via Raspberry Pi (contrôle GPIO en Python)
- Affichage LCD pour les notifications en local
- Reconnaissance d’images via **OpenCV**
- Traitement et classification visuelle (lettres, visages, chiffres) via **TensorFlow**
- Utilisation du dataset **MNIST** pour l’apprentissage machine

---

## 🏗️ Architecture technique
``` text
| Composant        | Technologie utilisée |
|------------------|----------------------|
| **Frontend**     | Flutter              |
| **Backend**      | Node.js, Express     |
| **Base de données** | MongoDB (NoSQL)  |
| **Notification Push** | Firebase         |
| **Hardware**     | Raspberry Pi + Python (RPi.GPIO, RPiLCD) |
| **Computer Vision** | OpenCV + TensorFlow (modèle MNIST) |
```
---

## 🔗 Technologies et APIs intégrées

- **Flutter** : Interface utilisateur (UI) multiplateforme
- **Node.js** : API RESTful backend
- **MongoDB** : Stockage flexible des données
- **Firebase** : Authentification et notifications en temps réel
- **Google Maps API** : Localisation des lettres
- **OpenCV / TensorFlow** : Traitement et reconnaissance d’images
- **Raspberry Pi** : Matériel embarqué pour actions physiques

---

## 📸 Captures d’écran

### Admin :
![Capture d'écran](images/ma_capture.png)

_Figure 4: Interface de l’administrateur_
![Capture d'écran](images/ma_capture.png)

### Utilisateur :
_Figure 5: Interface utilisateur complète (inscription, carte, profil, etc.)_
![Capture d'écran](images/ma_capture.png)

---

## ⚙️ Installation & Lancement

### Prérequis

- Flutter SDK
- Node.js et npm
- MongoDB (local ou distant)
- Raspberry Pi avec Python 3

### Backend

```bash
cd backend/
npm install
npm start
```

👥 Équipe de projet
Decaho Gbegbe – Développement mobile & UI/UX
mayssatbe - Coordinatrice de projet
nujhattt - charger de la configuration AI
sultanoloyede - Charger de l'assemblage de materiel physiques
AyaChiatou - Charger des requiements duratn tout le projet (charger de gestion de ressources)
EsdrasSoumaili - Charger du suivi et du respect des delais des differentes parties du projet

🎓 Contexte
Projet réalisé dans le cadre du cours CEG 4912-13 à l'université d'Ottawa,
comme travail de fin d’études visant à explorer l'intégration des technologies mobiles, du matériel embarqué (IoT), du traitement d'image et des systèmes intelligents.

📄 Licence
Ce projet est distribué sous la licence MIT. Voir le fichier LICENSE pour plus d’informations.

📬 Contact
Pour toute question ou collaboration :
📧 decahogbegbe@gmail.com
📍 Gatineau, QC, Canada
