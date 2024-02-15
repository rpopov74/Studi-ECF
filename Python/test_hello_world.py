import pytest
from pyspark.sql import SparkSession

@pytest.fixture(scope="module")
def spark_session():
    """Fixture pour créer une session Spark pour les tests."""
    spark = SparkSession.builder \
        .appName("Test Hello World PySpark") \
        .master("local[2]") \
        .getOrCreate()
    yield spark
    spark.stop()

def test_dataframe_creation(spark_session):
    """Teste la création du DataFrame Spark."""
    data = [("Coucou STUDI!",)]
    columns = ["Message"]
    df = spark_session.createDataFrame(data, columns)
  
    # Vérifier que les nom de la colonne est correcte
    assert df.columns == ["Message"]

    # Vérifier que les données dans le DataFrame sont correctes
    collected_data = df.collect()
    assert collected_data[0]["Message"] == "Coucou STUDI!"
