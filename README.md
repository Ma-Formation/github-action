
# GitHub Actions - Guide de Référence

## Introduction

GitHub Actions est un outil d'intégration et de livraison continues (CI/CD) intégré directement dans GitHub. Il te permet d'automatiser, tester et déployer ton code en définissant des **workflows**. Un workflow est un ensemble d'actions déclenchées par un événement, comme un commit ou une pull request.

## Structure de base d'un Workflow

Un workflow est défini dans un fichier YAML situé dans le dossier `.github/workflows/` à la racine de ton dépôt. Voici les principales composantes :

### 1. **name** (Nom du workflow)
Le champ `name` est optionnel, mais il permet de donner un nom à ton workflow. Si ce champ est omis, GitHub utilisera le nom du fichier YAML.

```yaml
name: Nom de mon workflow
```

### 2. **on** (Événement déclencheur)
Le champ `on` définit les événements qui déclenchent le workflow. Il peut s'agir de plusieurs événements comme `push`, `pull_request`, `workflow_dispatch`, etc.

```yaml
on:
  push:            # Déclenché sur un push
    branches:
      - main       # Spécifie les branches
  pull_request:    # Déclenché sur une PR
  schedule:        # Exécuter périodiquement
    - cron: "0 0 * * 1"  # Chaque lundi à minuit
```

### 3. **jobs** (Tâches à exécuter)
Un workflow est composé d'un ou plusieurs jobs. Chaque job est exécuté sur un **runner** (environnement virtuel). Les jobs sont définis dans la section `jobs` et sont exécutés en parallèle par défaut, à moins que tu utilises `needs` pour créer une dépendance entre eux.

#### Exemple d'un job basique :
```yaml
jobs:
  build:
    runs-on: ubuntu-latest  # Choix du runner (ex. ubuntu, macos, windows)
    steps:
      - name: Checkout du code
        uses: actions/checkout@v3
        
      - name: Configurer Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'

      - name: Installer les dépendances
        run: npm install

      - name: Exécuter les tests
        run: npm test
```

### 4. **steps** (Étapes)
Chaque `job` contient des étapes (`steps`) qui décrivent les actions individuelles. Il peut s'agir d'exécuter des commandes (`run`) ou d'utiliser des actions prédéfinies (`uses`).

- **run** : Permet d'exécuter directement une commande dans le runner.
- **uses** : Permet d'utiliser une action réutilisable, souvent depuis le marketplace d'actions GitHub.

#### Exemple d'une étape `run` :
```yaml
steps:
  - name: Exécuter une commande shell
    run: echo "Hello, GitHub Actions!"
```

#### Exemple d'une étape `uses` :
```yaml
steps:
  - name: Utiliser une action pour Node.js
    uses: actions/setup-node@v3
    with:
      node-version: '16'
```

### 5. **env** (Variables d'environnement)
Les variables d'environnement peuvent être définies au niveau du workflow ou des jobs pour stocker des valeurs réutilisables.

```yaml
env:
  NODE_ENV: production
  DATABASE_URL: ${{ secrets.DATABASE_URL }}  # Secrets GitHub
```

### 6. **secrets** (Informations sensibles)
Les secrets sont utilisés pour gérer les informations sensibles (comme les clés API) et peuvent être stockés dans les paramètres du dépôt GitHub.

```yaml
jobs:
  build:
    steps:
      - name: Utiliser un secret
        run: echo "La clé est : ${{ secrets.MY_SECRET_KEY }}"
```

## Exemples de cas d'utilisation

### 1. Déploiement continu (CD) sur une branche `main`
```yaml
name: Déploiement

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout du code
        uses: actions/checkout@v3

      - name: Exécuter le script de déploiement
        run: ./deploy.sh
```

### 2. Exécution des tests sur chaque pull request
```yaml
name: Test PR

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout du code
        uses: actions/checkout@v3

      - name: Installer les dépendances
        run: npm install

      - name: Exécuter les tests
        run: npm test
```

## Runners GitHub

GitHub fournit des **runners hébergés** (Ubuntu, Windows, MacOS) pour exécuter les workflows. Tu peux aussi utiliser tes propres **self-hosted runners** si tu as des besoins spécifiques.

### Runners hébergés :
- `ubuntu-latest`
- `windows-latest`
- `macos-latest`

## Meilleures pratiques

1. **Modulariser les workflows** : Divise les workflows en plusieurs fichiers pour mieux gérer leur complexité.
2. **Réutilisation des actions** : Utilise des actions du marketplace pour éviter de réécrire du code déjà disponible.
3. **Secrets** : Utilise les `secrets` pour sécuriser tes informations sensibles.
4. **Testing** : Toujours tester tes workflows localement avec des outils comme [act](https://github.com/nektos/act) avant de les pousser.

## Ressources

- [Documentation GitHub Actions](https://docs.github.com/actions)
- [GitHub Marketplace](https://github.com/marketplace?type=actions)
