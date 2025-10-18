#!/bin/bash
# rebuild_apertium.sh - Script de compilation pour Apertium Ewondo
# Ce script nettoie, compile et génère les fichiers .mode avec chemins relatifs

set -e  # Arrêt en cas d'erreur

echo "🔹 Nettoyage des fichiers générés..."

# Fichiers HFST générés
rm -f ewo.automorf.hfst ewo.autogen.hfst ewo.mor.hfst ewo.mor.twol.hfst \
      ewo.twol.hfst ewo.seg.hfst ewo.autoseg.hfst ewo.gen.hfst ewo.LR.lexc.hfst

# Fichiers binaires / att.gz
rm -f ewo.automorf.bin ewo.autogen.bin ewo.autogen.att.gz ewo.autoseg.att.gz ewo.rlx.bin

# Dossier .deps
rm -rf .deps

# Supprimer les anciens .mode
rm -f modes/*.mode
mkdir -p modes/

echo "✅ Fichiers générés supprimés."
echo ""

echo "🔹 Exécution de autogen.sh..."
if [ ! -f "autogen.sh" ]; then
    echo "❌ Erreur : autogen.sh introuvable !"
    exit 1
fi
./autogen.sh

echo ""
echo "🔹 Création d'un fichier .mode temporaire pour satisfaire make..."
# Créer un fichier temporaire pour que make ne plante pas
touch modes/ewo-morph.mode

echo ""
echo "🔹 Compilation avec make..."
make

echo ""
echo "🔹 Suppression des .mode temporaires et création des vrais fichiers..."
rm -f modes/*.mode

# Créer les fichiers .mode avec chemins relatifs
cat > modes/ewo-morph.mode << 'EOF'
hfst-proc -w ewo.automorf.hfst
EOF

cat > modes/ewo-gener.mode << 'EOF'
hfst-proc -g ewo.autogen.hfst
EOF

cat > modes/ewo-tagger.mode << 'EOF'
hfst-proc -w ewo.automorf.hfst | cg-proc -w ewo.rlx.bin
EOF

cat > modes/ewo-disam.mode << 'EOF'
hfst-proc -w ewo.automorf.hfst | cg-conv -a | vislcg3 --trace --grammar ewo.rlx.bin
EOF

cat > modes/ewo-twol.mode << 'EOF'
hfst-strings2fst -S | hfst-compose-intersect ewo.twol.hfst | hfst-fst2strings
EOF

cat > modes/ewo-lexc.mode << 'EOF'
hfst-lookup ewo.LR.lexc.hfst
EOF

echo "✅ Fichiers .mode créés dans modes/ :"
ls -1 modes/*.mode

echo ""
echo "🔹 Vérification des chemins (doivent être dans le dossier actuel) :"
CURRENT_DIR=$(basename "$PWD")
REAL_PATH=$(realpath modes/ewo-morph.mode)
echo "Dossier actuel : $CURRENT_DIR"
echo "Chemin réel : $REAL_PATH"

if [[ "$REAL_PATH" == *"$CURRENT_DIR/modes"* ]]; then
    echo "✅ Les fichiers .mode sont dans le bon dossier !"
else
    echo "⚠️  Attention : Vérifiez que vous êtes dans le bon dossier"
    echo "   pwd dit : $(pwd)"
    echo "   realpath dit : $(realpath .)"
fi

echo ""
echo "🔹 Test rapide du transducteur morphologique..."
if [ -f "ewo.automorf.hfst" ]; then
    echo "Test : 'mëbu'"
    echo "mëbu" | apertium -d . ewo-morph || echo "⚠️  Test échoué"
else
    echo "⚠️  Fichier ewo.automorf.hfst introuvable"
fi

echo ""
echo "🎉 Compilation terminée !"
echo ""
echo "📝 Pour utiliser vos modes :"
echo "   echo 'texte' | apertium -d . ewo-morph"
echo "   echo 'texte' | apertium -d . ewo-tagger"
echo ""
echo "📂 Emplacement : $(pwd)"
echo "📋 Contenu d'un fichier .mode :"
echo "---"
cat modes/ewo-morph.mode
echo "---"