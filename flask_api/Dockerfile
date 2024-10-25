# Utilisez l'image Python comme base
FROM python:3.9

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    gcc \
    make \
    libssl-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer mcrcon
RUN curl -L https://github.com/Tiiffi/mcrcon/archive/refs/tags/v0.7.1.tar.gz -o mcrcon.tar.gz \
    && tar -xzf mcrcon.tar.gz \
    && cd mcrcon-0.7.1 \
    && gcc -o mcrcon mcrcon.c -std=gnu99 -O2 \
    && cp mcrcon /usr/local/bin/ \
    && cd .. \
    && rm -rf mcrcon-0.7.1 mcrcon.tar.gz

# Définir le répertoire de travail
WORKDIR /app

# Copier le code de l'application
COPY . .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port
EXPOSE 5000

CMD ["python", "app.py"]