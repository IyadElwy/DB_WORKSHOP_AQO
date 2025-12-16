FROM jupyter/pyspark-notebook:latest

USER root

# Install system packages
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create python symlink in multiple locations to ensure it's found
RUN ln -sf /opt/conda/bin/python3 /opt/conda/bin/python && \
    ln -sf /opt/conda/bin/python3 /usr/bin/python && \
    ln -sf /opt/conda/bin/python3 /usr/local/bin/python

# Install Python packages
RUN pip install --no-cache-dir \
    delta-spark==3.0.0 \
    pandas==2.1.4 \
    matplotlib==3.8.2 \
    seaborn==0.13.0 \
    plotly==5.18.0 \
    pyarrow==14.0.1 \
    s3fs==2023.12.0 \
    boto3==1.34.10 \
    tqdm==4.66.1 \
    kaleido==0.2.1

# Download Hadoop AWS and Delta Lake JARs
RUN mkdir -p /opt/spark/jars && \
    cd /opt/spark/jars && \
    curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar && \
    curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.262/aws-java-sdk-bundle-1.12.262.jar && \
    curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar && \
    curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.4.0/delta-storage-2.4.0.jar

# Configure Spark defaults
RUN echo "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.endpoint=http://minio:9000" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.access.key=admin" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.secret.key=admin123" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.path.style.access=true" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.hadoop.fs.s3a.connection.ssl.enabled=false" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.sql.adaptive.enabled=true" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.sql.adaptive.coalescePartitions.enabled=true" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.sql.adaptive.skewJoin.enabled=true" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.executor.memory=2g" >> /usr/local/spark/conf/spark-defaults.conf && \
    echo "spark.driver.memory=2g" >> /usr/local/spark/conf/spark-defaults.conf

# Create work directories
RUN mkdir -p /home/jovyan/work /home/jovyan/data && \
    chown -R jovyan:users /home/jovyan/work /home/jovyan/data

# Switch back to jovyan user
USER jovyan

# Set working directory
WORKDIR /home/jovyan/work