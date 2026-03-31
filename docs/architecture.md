# Architecture

## High-Level Architecture

```
Raw Source Data (CSV / External Sources)
        │
        ▼
Seeds (Raw Tables - Bronze Layer)
        │
        ▼
Staging Models (Standardization Layer)
        │
        ▼
Intermediate Models (Business Logic Layer)
        │
        ▼
Fact Table (Analytics Layer)
        │
        ▼
Consumption Layer (BI / Analytics)
```

---

## Medallion Data Architecture

| Layer  | Purpose                          | Implementation                |
| ------ | -------------------------------- | ----------------------------- |
| Bronze | Raw data ingestion               | dbt Seeds                     |
| Silver | Cleaned and transformed data     | Staging + Intermediate models |
| Gold   | Business-ready analytical models | Fact table                    |

---

## Logical Data Flow

```
sample
test
result
lot
item
        │
        ▼
stg_sample
stg_test
stg_result
stg_lot
stg_item
        │
        ▼
int_final
        │
        ▼
fact_results
```

---

## Data Pipeline Layers

### Bronze Layer

**Purpose**

Store raw source data as-is.

Implementation:

```
dbt seed
```

Tables:

```
sample
test
result
lot
item
```

---

### Staging Layer

**Purpose**

Standardize and prepare raw data.

Transformations include:

* column selection and renaming
* data type alignment
* basic cleansing

Models:

```
stg_sample
stg_test
stg_result
stg_lot
stg_item
```

---

### Intermediate Layer

**Purpose**

Apply core business logic and transformations.

Transformations include:

* multi-table joins
* filtering (`status = 'A'`, non-null checks)
* window function for latest record selection

Model:

```
int_final
```

---

### Gold Layer (Mart)

**Purpose**

Provide business-ready analytical dataset.

Transformations include:

* final column selection
* audit column addition
* flattened structure for analytics

Model:

```
fact_results
```

---

## Physical Architecture

```
Compute Engine: DBT Core
Execution Engine: DuckDB
Storage: healthcare_lab.duckdb
Transformation Language: SQL
Version Control: Git
```

---

## Data Lineage

```
sample
test
result
lot
item
        │
        ▼
stg_models
        │
        ▼
int_final
        │
        ▼
fact_results
```

---

## Execution Flow

```
dbt seed
dbt run
dbt test
```
