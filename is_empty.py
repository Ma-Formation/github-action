import sys

# Vérifie si un argument a été passé
if len(sys.argv) != 2:
    print("Usage: python is_empty.py <nombre>")
    sys.exit(1)

# Récupère l'argument depuis la ligne de commande
try:
    number = int(sys.argv[1])
except ValueError:
    print("Veuillez entrer un nombre valide.")
    sys.exit(1)

# Vérification si le nombre est pair ou impair
if number % 2 == 0:
    print(f"Le nombre {number} est pair.")
else:
    print(f"Le nombre {number} est impair.")
