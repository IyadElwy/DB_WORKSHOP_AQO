# Jupyter Notebook Configuration for Lakehouse Query Optimization Demo

import os

# Spark Configuration
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.token = ''
c.NotebookApp.password = ''

# Environment variables for PySpark
os.environ['PYSPARK_SUBMIT_ARGS'] = """
--packages io.delta:delta-core_2.12:2.4.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262
--conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension
--conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem
--conf spark.hadoop.fs.s3a.endpoint=http://minio:9000
--conf spark.hadoop.fs.s3a.access.key=admin
--conf spark.hadoop.fs.s3a.secret.key=admin123
--conf spark.hadoop.fs.s3a.path.style.access=true
--conf spark.hadoop.fs.s3a.connection.ssl.enabled=false
--conf spark.sql.adaptive.enabled=true
--conf spark.sql.adaptive.coalescePartitions.enabled=true
--conf spark.sql.adaptive.skewJoin.enabled=true
--conf spark.sql.adaptive.localShuffleReader.enabled=true
--conf spark.executor.memory=2g
--conf spark.driver.memory=2g
--conf spark.driver.maxResultSize=1g
--conf spark.sql.shuffle.partitions=200
pyspark-shell
""".replace('\n', ' ')

# Plotly renderer for Jupyter Lab
os.environ['PLOTLY_RENDERER'] = 'jupyterlab'
