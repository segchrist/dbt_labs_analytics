Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


Creation d'environnement dev et prod (mais utilisation des meme informations d'identification)
brancher le projet à mon compte github

creation d'une dimension date en utilisant les fonctions de date de snow tel que dayname, to_timestamp, et des fonctions sql case when 
creation du modele daily_weather qui agrège les données météo par jour(initialement par heure)  et sélectionne, pour chaque date, le type de météo le plus fréquent afin de créer une vue journalière représentative(utilisation des window function et qualify qui permet de filtrer le resultat d'une window function)