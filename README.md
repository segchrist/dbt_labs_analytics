### Projet : Pipeline d’Ingestion & Modélisation CitiBike + Weather

(Snowflake + dbt)

# Objectif

Ce projet met en place un pipeline complet de data engineering permettant d’ingérer, nettoyer, transformer et modéliser :

des données de trajets de vélos (CitiBike),

des données météo journalières issues de fichiers JSON.

L’objectif est de reproduire une architecture moderne orientée ingestion automatisée, modélisation analytique et orchestration, sans se concentrer sur la visualisation.

# 🧱 Architecture globale

L'architecture suit une structure en plusieurs couches :

- Sources brutes :

    fichiers JSON météo stockés dans un bucket S3 (stage externe),

    fichiers CSV CitiBike (stage interne).

- Zones d’ingestion Snowflake :

    un stage externe pour la météo,

    un stage interne pour les données CitiBike.

- Tables RAW :

    une table pour la météo,

    une table pour les trajets.

- Modélisation dbt :

    modèles de staging,

    dimensions (date, station),

    table de faits (trajets),

    modèle final combinant trajets + météo dominante du jour.

- Orchestration :

    tâches Snowflake programmées pour l’ingestion,

    job dbt exécuté automatiquement chaque jour à 1h.

# Ingestion des données météo

Les données météo proviennent d’un bucket S3 contenant des fichiers JSON, chacun représentant une journée complète de données à New York.

Un stage externe Snowflake permet d’accéder directement à ces fichiers.
Une tâche Snowflake quotidienne, exécutée à minuit, lit les fichiers JSON et les charge dans la table RAW dédiée.

# Ingestion des données CitiBike

Les fichiers CSV CitiBike sont chargés dans un stage interne Snowflake depuis la machine locale.
Ils sont ensuite ingérés dans la table RAW via une tâche Snowflake exécutée chaque heure.

Cette approche permet un chargement progressif et continu des données.

# Déclaration des sources dbt

Les deux tables RAW (bikes et weather) sont déclarées comme « sources » dans dbt.
Cela permet de :

    structurer la documentation,

    renforcer le lineage,

    activer des tests de qualité,

    améliorer la lisibilité du pipeline.

# Étape de Staging dbt

La couche staging standardise les données :

    nettoyage des fichiers CSV CitiBike (suppression des guillemets parasites et des lignes invalides),

    normalisation des colonnes,

    préparation des données pour la modélisation.

Le staging agit comme un tampon propre entre les tables brutes et les modèles analytiques.

# Macros dbt

Deux macros ont été créées pour enrichir les données temporelles :

    détermination de la saison à partir d’une date,

    classification des jours en week-end ou jour ouvré.

Ces transformations évitent la duplication de logique dans les modèles.

# Dimension Date

La dimension date fournit des informations enrichies telles que :

    la date,

    l’heure,

    la saison,

    le type de jour,

    et d’autres attributs utiles aux analyses.

Elle permet d’analyser les trajets selon le temps, l'heure, la saisonnalité ou les cycles hebdomadaires.

# Dimension Station

La dimension station extrait les métadonnées des stations :

    identifiant,

    nom,

    position géographique.

Elle constitue une table de référence unique et propre.

# Table de faits : trajets

La table de faits rassemble les mesures clés liées aux trajets :

    date du trajet,

    station de départ et station d'arrivée,

    type d’utilisateur,

    durée du trajet, calculée à partir des timestamps.

Elle est directement nourrie par le modèle de staging.

# Modélisation météo journalière

Les données météo initialement horaires sont agrégées pour produire une table journalière.
Cette table contient :

    la météo dominante du jour,

    les moyennes de température, de pression, de couverture nuageuse et d'humidité.

Cette vue simplifiée facilite le croisement avec les trajets.

# Modèle final : trajets + météo

Le modèle final combine :

    la table de faits des trajets,

    la météo journalière.

Résultat : une table analytique enrichie, permettant d’étudier les comportements d’utilisation du service de vélos en fonction des conditions météorologiques.

# Orchestration du pipeline

Le pipeline fonctionne automatiquement grâce à :

    une tâche Snowflake quotidienne pour l’ingestion météo,

    une tâche Snowflake horaire pour l’ingestion des trajets,

    un job dbt horaire pour exécuter l’ensemble des modèles.

Cette orchestration assure une mise à jour continue et fiable des données.