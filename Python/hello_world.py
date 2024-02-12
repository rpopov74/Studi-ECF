from pyspark.sql import SparkSession

# Initialiser une session Spark
spark = SparkSession.builder \
    .appName("Hello World PySpark") \
    .getOrCreate()

# Créer un DataFrame Spark simple
data = [("Coucou STUDI!",)]
columns = ["Message"]
df = spark.createDataFrame(data, columns)

# Afficher le message
df.show()

# Arrêter la session Spark
spark.stop()