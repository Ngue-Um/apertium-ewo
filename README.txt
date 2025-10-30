
````
# Apertium Ewondo (ewo)

**Apertium Ewondo** is a morphological analyser and tagger for the **Ewondo** language, a Bantu language spoken in Cameroon.  
This module is developed within the Apertium ecosystem to support the creation of rule-based translation and language processing tools for low-resourced African languages.

---

## Prerequisites

Before installation, ensure that the following packages are available:

- **HFST** (>= 3.15.1)  
- **Apertium** (>= 3.6.1)  
- **CG3** (>= 1.3.1)

On Ubuntu/Debian systems:
```bash
sudo apt install apertium hfst cg3
````

---

## Quick Installation

```bash
git clone https://github.com/Ngue-Um/apertium-ewo.git
cd apertium-ewo
./setup.sh
```

---

## Manual Installation

If you prefer to rebuild manually:

```bash
git clone https://github.com/Ngue-Um/apertium-ewo.git
cd apertium-ewo
./rebuild_apertium.sh
```

---

## Usage Examples

### Morphological Analysis

```bash
echo "elum" | apertium -d . ewo-morph
^elum/lum<n><cl7><sg>$
```

### Tagging

```bash
echo "mvol" | apertium -d . ewo-tagger
^mvol/mvol<n><cl10><pl>/mvol<n><cl9><sg>$
```

### Generation

```bash
echo "^mvol/mvol<n><cl10><pl>/mvol<n><cl9><sg>$" | bash modes/ewo-gener.mode
#mvol\/mvol\/mvol
```

### Disambiguation

```bash
echo "etun" | apertium -d . ewo-disam
"<etun>"
        "tun" inf
        "tun" n cl7 sg
```

---

## Project Structure

```
apertium-ewo/
├── apertium-ewo.ewo.lexc        # Lexicon
├── apertium-ewo.ewo.twol        # Phonological rules
├── apertium-ewo.ewo.mor.twol    # Morphophonological rules
├── apertium-ewo.ewo.rlx         # Disambiguation (CG3)
├── apertium-ewo.ewo.spellrelax  # Orthographic relaxation
├── modes.xml                    # Mode configuration
├── rebuild_apertium.sh          # Compilation script
├── setup.sh                     # Installation script
└── modes/                       # Generated .mode files
```

---

## Development

### Editing the Lexicon

Edit `apertium-ewo.ewo.lexc` and recompile:

```bash
./rebuild_apertium.sh
```

### Editing Phonological Rules

Edit `apertium-ewo.ewo.twol` and recompile.

### Editing Disambiguation Rules

Edit `apertium-ewo.ewo.rlx` and recompile.

---

## Important Notes

* `.mode` files are generated automatically using **relative paths**.
* Do **not** commit generated files (`.hfst`, `.bin`, `.mode`).
* Always use `./rebuild_apertium.sh` for clean and consistent recompilation.

---

## Known Issues

If `apertium-gen-modes` fails with a **segmentation fault**,
the `rebuild_apertium.sh` script automatically creates `.mode` files manually with relative paths.

---

## ✅ Functional Modes Overview

| Mode           | Status        | Function               | Command Example                                                               |
| -------------- | ------------- | ---------------------- | ----------------------------------------------------------------------------- |
| **ewo-morph**  | ✅ Perfect     | Morphological analysis | `echo "elum" \| apertium -d . ewo-morph`                                      |
| **ewo-tagger** | ✅ Perfect     | Tagging                | `echo "mvol" \| apertium -d . ewo-tagger`                                     |
| **ewo-disam**  | ✅ Perfect     | Disambiguation         | `echo "etun" \| apertium -d . ewo-disam`                                      |
| **ewo-lexc**   | ✅ Working     | Lexicon lookup         | `echo "elum" \| apertium -d . ewo-lexc`                                       |
| **ewo-gener**  | ⚠️ Workaround | Generation             | `echo "^mvol/mvol<n><cl10><pl>/mvol<n><cl9><sg>$" \| apertium -d . ewo-gener` |

---

