
  
  create view "healthcare_lab"."main"."int_final__dbt_tmp" as (
    

WITH base AS (

    SELECT
        LEFT(A.label_id, 11) AS lot,
        LEFT(A.label_id, 10) AS join_id,
        'tall' AS site,
        'mall' AS category,

        A.date_completed,
        A.product,
        A.product_grade,
        A.stage,
        A.sample_number,

        E.name AS parameter,
        E.entry AS result_value,
        E.units,

        F.item_description AS lot_description,

        B.sample_number AS test_sample_number,
        B.reported_name,
        B.test_number,
        B.status AS test_status,
        B.date_completed AS result_captured_date,
        B.x_method

    FROM "healthcare_lab"."main"."sample" A

    LEFT JOIN "healthcare_lab"."main"."result" E 
        ON A.sample_number = E.sample_number

    LEFT JOIN "healthcare_lab"."main"."test" B 
        ON E.test_number = B.test_number

    LEFT JOIN "healthcare_lab"."main"."lot" C 
        ON C.lot_name = LEFT(A.label_id, 11)

    LEFT JOIN "healthcare_lab"."main"."item" F 
        ON F.lot_number = C.lot_name

    WHERE E.name IS NOT NULL
      AND E.status = 'A'
      AND B.status = 'A'
      AND E.entry IS NOT NULL
),

latest AS (

    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY lot
            ORDER BY result_captured_date DESC
        ) AS rnk
    FROM base
)

SELECT *
FROM latest
WHERE rnk = 1
  );
