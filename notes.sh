#!/bin/bash

# Initialiser un nouveau dépôt Git
git init

# Ajouter des fichiers suivis par Git
git add <fichier>

# Confirmer les modifications avec un message
git commit -m "message du commit"

# Afficher l'état des fichiers (modifiés, ajoutés, supprimés)
git status

# Afficher l'historique des commits
git log

# Créer une nouvelle branche
git branch <nom_de_la_branche>

# Passer à une autre branche
git checkout <nom_de_la_branche>

# Fusionner une branche dans la branche courante
git merge <nom_de_la_branche>

# Cloner un dépôt distant
git clone <url_du_depot>

# Pousser les modifications vers le dépôt distant
git push origin <nom_de_la_branche>

# Récupérer les dernières modifications du dépôt distant
git pull

# Afficher les différences entre les fichiers
git diff

# Renommer une branche
git branch -m <nouveau_nom>

# Supprimer une branche locale
git branch -d <nom_de_la_branche>

# Réinitialiser le HEAD à un commit précédent
git reset --hard <commit>

# Annuler le dernier commit tout en gardant les modifications
git reset --soft HEAD~1

# Voir les branches locales et distantes
git branch -a

# Ajouter un dépôt distant
git remote add origin <url_du_depot>

# Voir les dépôts distants
git remote -v

# Supprimer un fichier suivi par Git
git rm <fichier>

# Stasher les changements locaux
git stash

# Récupérer les changements stashed
git stash pop

# Modifier le dernier commit (sans changer son hash)
git commit --amend --no-edit

# Creer un tag
git tag -a <nom du tag> -m "commentaire"
git push origin  --tags

-------------------------------------------

# Github Action 
- jobs: serie de steps
- steps: serie de taches
