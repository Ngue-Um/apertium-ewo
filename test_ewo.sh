#!/bin/bash
# test_apertium.sh - tests personnalisés pour Apertium Ewondo

echo "🔹 Test morphologique"
echo "elum" | apertium -d . ewo-morph


# echo ""
# echo "🔹 Test de désambiguïsation"
# echo "etun" | apertium -d . ewo-disam

# echo ""
# echo "🔹 Test du lexique"
# echo "mvol" | apertium -d . ewo-lexc
# echo "eba" | apertium -d . ewo-morph
# echo "abag" | apertium -d . ewo-morph
# echo "eban" | apertium -d . ewo-morph
# echo "banga eban" | apertium -d . ewo-morph
echo "eba" | apertium -d . ewo-disam
