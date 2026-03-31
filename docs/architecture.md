# Architecture & Transformations

## Overview

The transformation logic converts raw laboratory datasets into a business-ready analytical dataset by applying joins, filters, and deduplication logic. The pipeline is implemented using layered DBT models to ensure modularity and maintainability.

---

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

**Implementation**

```
dbt seed
```

**Tables**

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

**Transformations include**

* column selection and renaming
* data type alignment
* basic cleansing

**Models**

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

**Transformations include**

* multi-table joins
* filtering (`status = 'A'`, non-null checks)
* window function for latest record selection

**Model**

```
int_final
```

---

### Gold Layer (Mart)

**Purpose**

Provide business-ready analytical dataset.

**Transformations include**

* final column selection
* audit column addition
* flattened structure for analytics

**Model**

```
fact_results
```

---

## Key Transformation Steps

### Data Ingestion (Seeds Layer)

Raw datasets (`sample`, `test`, `result`, `lot`, `item`) are ingested using DBT seeds and stored as raw tables in DuckDB.

**Purpose**

* Provide a reproducible input dataset
* Act as the source layer for all downstream transformations

---

### Staging Layer (Standardization)

**Models**

```
stg_sample
stg_test
stg_result
stg_lot
stg_item
```

**Key Operations**

* Direct mapping from raw tables
* Column selection and alignment
* Preparation for downstream joins

**Purpose**

* Isolate raw data from transformation logic
* Provide a clean and consistent schema

---

### Intermediate Layer (Core Business Logic)

**Model**

```
int_final
```

---

#### Join Logic

* `sample` joined with `result` using `sample_number`
* `result` joined with `test` using `test_number`
* `sample` joined with `lot` using derived key:

```
LEFT(label_id, 11)
```

* `lot` joined with `item` using `lot_number`

**Purpose**

Combine multiple domain datasets into a unified structure

---

#### Derived Columns

* `lot` → extracted from `label_id`
* `join_id` → truncated identifier
* Static fields:

  * `site = 'tall'`
  * `category = 'mall'`

**Purpose**

Standardize identifiers and enrich dataset

---

#### Filtering Logic

Records are filtered based on:

* `result.name IS NOT NULL`
* `result.entry IS NOT NULL`
* `result.status = 'A'`
* `test.status = 'A'`

**Purpose**

* Ensure only valid and active records are processed
* Improve data quality

---

#### Deduplication / Latest Record Selection

A window function is applied:

```
ROW_NUMBER() OVER (
    PARTITION BY lot
    ORDER BY result_captured_date DESC
)
```

Only records with:

```
rnk = 1
```

are retained.

**Purpose**

* Select the most recent result per lot
* Remove historical duplicates

---

### Mart Layer (Final Output)

**Model**

```
fact_results
```

**Key Transformations**

* Select business-relevant columns
* Rename `result_value` → `entry`

Add audit columns:

```
CURRENT_TIMESTAMP AS edl_inrt_dttm
CURRENT_TIMESTAMP AS edl_last_modf_dttm
```

**Purpose**

* Provide a flattened, analytics-ready dataset
* Enable downstream reporting and analysis

---

## Data Quality Considerations

The pipeline ensures data quality through:

* filtering invalid/null records
* enforcing active status (`status = 'A'`)
* deduplication using window functions
* consistent join logic across datasets

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
