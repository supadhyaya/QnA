from pyspark.sql.types import StringType
from pyspark.sql.functions import udf,col
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext


sc = SparkContext()
sqlContext = SQLContext(sc)

APP_NAME = "Transformation of Big Data"

rdd = sc.textFile("2017-10-01-10.json")

df = sqlContext.read.json(rdd)

new_df = (df.filter(df['type']=="PullRequestEvent")).select(col('created_at').alias('created_at'), col('repo.name').alias('repo_name'), 
															col('actor.login').alias('username'),col('payload.pull_request.user.login').alias('pr_username'),
															col('payload.pull_request.created_at').alias('pr_created_at'),col('payload.pull_request.head.repo.language').alias('pr_repo_language'))
def translate(mapping):
    def translate_(col):
        if mapping.get(col):
            return mapping.get(col)
        else:
            return('Other')
    return udf(translate_)

mapping = {
    'BASIC': 'Procedural', 'C': 'Procedural', 'C#': 'Object Oriented', 'C++': 'Object Oriented', 'Java': 'Object Oriented', 
    'Python': 'Object Oriented', 'Lisp': 'Functional', 'Haskell': 'Functional', 'Scala': 'Functional', 'R': 'Data Science', 
    'Jupyter Notebook': 'Data Science', 'Julia': 'Data Science'}
 
transform = new_df.withColumn("pr_repo_language_type", translate(mapping)("pr_repo_language"))

transform.write.mode('overwrite').parquet("spark_etl_04.parquet")


if __name__ == "__main__":
   # Configure Spark
   conf = SparkConf().setAppName(APP_NAME)
   conf = conf.setMaster("local[*]")

