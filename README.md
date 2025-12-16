# 📊 Data Lakehouse Query Optimization Demo

A complete, reproducible demonstration of query optimization in modern data lakehouses using Apache Spark, Delta Lake, and MinIO.

![Docker](https://img.shields.io/badge/Docker-Ready-blue)
![Spark](https://img.shields.io/badge/Apache%20Spark-3.5-orange)
![Delta Lake](https://img.shields.io/badge/Delta%20Lake-3.0-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## 🎯 Overview

This project demonstrates **why query optimization is essential** in data lakehouses through a practical, hands-on example based on the **VLDB 2024 paper** on query optimization.

### Key Features

- **Complete Docker Setup**: MinIO (S3-compatible storage), Spark, Jupyter, and Delta Lake
- **TPC-H Style Data**: Realistic data generation with 100k customers, 500k orders, 2M line items
- **Performance Comparison**: Demonstrates 10-20x speedup with proper optimization
- **Interactive Visualizations**: Publication-quality charts using Plotly
- **Educational**: Step-by-step notebook explaining optimization concepts

### What You'll Learn

1. **Performance Impact**: See real 10-20x speedup differences between optimization strategies
2. **Filter Selectivity**: Understand why 99%+ data reduction through filters matters
3. **Join Optimization**: Compare shuffle join vs. broadcast join performance
4. **Adaptive Query Execution (AQE)**: Learn how runtime optimization solves lakehouse challenges

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available for Docker
- 10GB free disk space

### Start the Demo

```bash
# Clone or extract the project
cd lakehouse-query-optimization-demo

# Start all services
docker-compose up -d

# Wait for services to be ready (~30 seconds)
docker-compose logs -f jupyter
```

### Access the Services

Once running, access:

- **Jupyter Lab**: http://localhost:8888 (no password required)
- **MinIO Console**: http://localhost:9001 (admin/admin123)
- **Spark UI**: http://localhost:4040 (available when running queries)

### Run the Demo

1. Open Jupyter Lab: http://localhost:8888
2. Navigate to `work/01_query_optimization_demo.ipynb`
3. Run all cells sequentially (Cell → Run All)
4. Explore the interactive visualizations

## 📁 Project Structure

```
lakehouse-query-optimization-demo/
├── docker-compose.yml              # Docker services configuration
├── Dockerfile                      # Jupyter + Spark container
├── jupyter_notebook_config.py      # Spark configuration
├── .devcontainer/
│   └── devcontainer.json          # VS Code remote development
├── notebooks/
│   └── 01_query_optimization_demo.ipynb  # Main demo notebook
├── README.md                       # This file
└── QUICKSTART.md                   # Presentation guide
```

## 📊 What the Notebook Demonstrates

### The Example Query (Q0)

From the VLDB 2024 paper:

```sql
SELECT c.c_name, o.o_orderdate, SUM(o.o_totalprice) AS revenue
FROM customer AS c, orders AS o
WHERE c.c_mktsegment = 'BUILDING'
  AND c.c_acctbal > 8000.0
  AND c.c_custkey = o.o_custkey
  AND o.o_orderdate BETWEEN '2024-03-15' AND '2024-04-15'
GROUP BY c.c_name, o.o_orderdate
ORDER BY revenue DESC
LIMIT 10
```

### Why This Query is Interesting

- **Highly selective filters**: Only ~0.2% of customers match (BUILDING segment + high balance)
- **Join operation**: Requires joining customer and orders tables
- **Optimization critical**: Wrong strategy = 100x more data movement

### Performance Comparison

| Strategy | Execution Time | Speedup | Key Features |
|----------|---------------|---------|--------------|
| No Optimization | Baseline | 1.0x | Full shuffle join, no filter pushdown |
| Basic Optimization | ~50% faster | 2-3x | Broadcast join, filter pushdown |
| Adaptive Query Execution (AQE) | ~90% faster | 10-20x | Runtime optimization, dynamic decisions |

### 12 Notebook Chapters

1. **Setup**: Imports and Spark session configuration
2. **Data Generation**: TPC-H style realistic data with distributions
3. **Data Analysis**: Understand data distributions and selectivity
4. **Query Q0**: Introduction to the example query
5. **No Optimization**: Baseline performance (shuffle join)
6. **Basic Optimization**: Broadcast join and filter pushdown
7. **AQE**: Adaptive Query Execution for best performance
8. **Performance Visualization**: Interactive comparison charts
9. **Filter Selectivity**: Analyze 500x data reduction
10. **Key Takeaways**: Summary of learnings
11. **Bonus Queries**: Additional examples
12. **Summary**: Wrap-up and next steps

## 🔧 Technical Details

### Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Docker Compose                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │    MinIO     │  │   Jupyter    │  │  Hive    │ │
│  │  (Storage)   │  │  + Spark     │  │Metastore │ │
│  │              │  │  + Delta     │  │(Optional)│ │
│  │  Port: 9000  │  │  Port: 8888  │  │Port: 9083│ │
│  │        9001  │  │        4040  │  │          │ │
│  └──────────────┘  └──────────────┘  └──────────┘ │
│         │                 │                │       │
│         └─────────────────┴────────────────┘       │
│              lakehouse-network (bridge)            │
└─────────────────────────────────────────────────────┘
```

### Technologies Used

- **Apache Spark 3.5**: Distributed data processing
- **Delta Lake 3.0**: ACID transactions and optimized storage
- **MinIO**: S3-compatible object storage
- **Jupyter Lab**: Interactive development environment
- **Plotly**: Interactive visualizations
- **Python Libraries**: pandas, matplotlib, seaborn, boto3

### Spark Configuration

Key settings for optimal performance:

```python
spark.sql.adaptive.enabled = true
spark.sql.adaptive.coalescePartitions.enabled = true
spark.sql.adaptive.skewJoin.enabled = true
spark.sql.autoBroadcastJoinThreshold = 10485760  # 10MB
spark.executor.memory = 2g
spark.driver.memory = 2g
```

## 📈 Data Distribution

The demo uses carefully crafted data distributions to demonstrate optimization:

### Customer Table (100,000 rows)

- **Market Segments**:
  - BUILDING: 4% (target segment for query)
  - AUTOMOBILE: 25%
  - MACHINERY: 20%
  - HOUSEHOLD: 30%
  - FURNITURE: 21%

- **Account Balance**:
  - High balance (>$8,000): 5%
  - Regular balance: 95%

- **Combined Selectivity**: ~0.2% of customers match both filters

### Orders Table (500,000 rows)

- Distributed across 2024
- Linked to customers via foreign key
- Average 5 orders per customer

### LineItem Table (2,000,000 rows)

- Average 4 line items per order
- Product details and pricing

## 🎓 Use Cases

### For Presentations

- Professional visualizations ready for slides
- Clear performance metrics and comparisons
- Real data demonstrating optimization impact
- Educational progression from basic to advanced

### For Learning

- Hands-on query optimization experience
- Understanding data lakehouse architecture
- Spark and Delta Lake best practices
- Performance tuning techniques

### For Development

- VS Code DevContainer support
- Full Spark development environment
- S3-compatible storage for testing
- Reproducible setup

## 🛠️ Customization

### Modify Data Size

Edit the notebook cells to change data volume:

```python
num_customers = 100000   # Change to 1M for larger dataset
num_orders = 500000      # Proportionally increase
num_lineitems = 2000000  # Proportionally increase
```

### Change Query Filters

Experiment with different selectivity:

```python
# More selective (fewer results)
c.c_acctbal > 9000

# Less selective (more results)
c.c_acctbal > 5000
```

### Add Custom Queries

Create new cells with your own TPC-H style queries to test different optimization scenarios.

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d
```

### Out of Memory Errors

Increase Docker memory limit:
- Docker Desktop → Settings → Resources → Memory → 6GB+

### Jupyter Notebook Errors

```bash
# Restart Jupyter service
docker-compose restart jupyter

# Check Jupyter logs
docker-compose logs jupyter
```

### MinIO Connection Issues

```bash
# Verify MinIO is healthy
docker-compose ps minio

# Test connectivity
curl http://localhost:9000/minio/health/live
```

### Spark UI Not Accessible

The Spark UI (port 4040) is only available when a Spark application is running. Execute a cell in the notebook first.

## 📝 Best Practices

### For Performance Testing

1. **Run warm-up queries**: First execution includes compilation overhead
2. **Multiple runs**: Average results across 3+ executions
3. **Clear cache**: Restart Spark context between major tests
4. **Monitor resources**: Check CPU/memory usage during execution

### For Production

1. **Enable AQE**: Always use Adaptive Query Execution
2. **Collect statistics**: Delta Lake table statistics for better optimization
3. **Partition data**: Strategic partitioning for query patterns
4. **Monitor plans**: Regularly check execution plans
5. **Tune memory**: Adjust executor/driver memory based on workload

## 🔗 Resources

### Documentation

- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [Delta Lake Documentation](https://docs.delta.io/)
- [MinIO Documentation](https://min.io/docs/)
- [Adaptive Query Execution](https://spark.apache.org/docs/latest/sql-performance-tuning.html#adaptive-query-execution)

### Papers and Articles

- VLDB 2024: Query Optimization in Data Lakehouses
- [TPC-H Benchmark Specification](http://www.tpc.org/tpch/)
- [Spark SQL Performance Tuning](https://spark.apache.org/docs/latest/sql-performance-tuning.html)

## 🤝 Contributing

Feel free to:
- Add more example queries
- Improve visualizations
- Add additional analysis
- Optimize configurations
- Report issues

## 📄 License

This project is available under the MIT License. Feel free to use it for educational and commercial purposes.

## 🙏 Acknowledgments

- Based on VLDB 2024 research on lakehouse query optimization
- TPC-H benchmark specification for data schema
- Apache Spark and Delta Lake communities

---

## 🎯 Next Steps

1. **Run the Demo**: Start with `docker-compose up -d`
2. **Explore the Notebook**: Execute all cells and explore results
3. **Review QUICKSTART.md**: Presentation guide and tips
4. **Customize**: Modify queries and data for your use case
5. **Present**: Use visualizations in your presentation

---

**Happy Optimizing!** 🚀

For questions or issues, please check the troubleshooting section or review the notebook comments.
