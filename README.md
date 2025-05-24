# roboshop-by-advanced-shell-script-

Roboshop Project - Automated Setup using Shell Script
Roboshop is an e-commerce application composed of multiple microservices. This project automates the installation and setup of all services using Shell scripts.

📦 Architecture Overview
The system is divided into 3 main tiers:

🔹 Frontend
Service: frontend

Provides the web user interface.

Runs on its own instance.

🔹 Databases
Used for different data handling requirements:

MongoDB – NoSQL (Used by catalogue and user)

MySQL – RDBMS (Used by shipping)

Redis – Caching layer (Used by cart)

RabbitMQ – Messaging queue (Used by payment)

🔹 Backend / Application Services
Each service runs on a separate instance:

Service	Purpose
catalogue	Displays product categories
user	Manages user data and sessions
cart	Handles shopping cart logic
shipping	Manages shipping and delivery
payment	Handles payment logic
dispatch	Handles dispatch tracking

🛠️ Automation
All installations and service configurations are handled using Shell scripts.

Each script:

Installs dependencies

Sets up the service

Configures the database connection

Enables and starts the service

🚀 Getting Started
Clone the repository and run the setup scripts for each component in order (e.g., databases → backend → frontend).

Common code can be create as one `main_common.sh` file, this common file can be called where ever required. In `main_common.sh` some function are also defined.