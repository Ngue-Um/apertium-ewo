#!/bin/bash
# setup.sh - Script d'installation pour les collaborateurs
# Usage: ./setup.sh

set -e

echo "🚀 Configuration d'Apertium Ewondo"
echo ""

# Vérifier les dépendances
echo "🔍 Vérification des dépendances..."
command -v hfst-lexc >/dev/null 2>&1 || { echo "❌ HFST n'est pas installé. Installez-le avec : sudo apt install hfst"; exit 1; }
command -v apertium >/dev/null 2>&1 || { echo "❌ Apertium n'est pas installé. Installez-le avec : sudo apt install apertium"; exit 1; }
command -v cg-comp >/dev/null 2>&1 || { echo "❌ CG3 n'est pas installé. Installez-le avec : sudo apt install cg3"; exit 1; }

echo "✅ Toutes les dépendances sont installées"
echo ""

# Rendre rebuild_apertium.sh exécutable
if [ -f "rebuild_apertium.sh" ]; then
    chmod +x rebuild_apertium.sh
    echo "✅ rebuild_apertium.sh est maintenant exécutable"
else
    echo "❌ Erreur : rebuild_apertium.sh introuvable !"
    exit 1
fi
chmod +x test_ewo.sh

echo ""
echo "🔹 Compilation du projet..."
./rebuild_apertium.sh

echo ""
echo "🎉 Installation terminée !"
echo ""
echo "📝 Vous pouvez maintenant utiliser :"
echo "   echo 'mëbu' | apertium -d . ewo-morph"
echo "   echo 'texte' | apertium -d . ewo-tagger"
