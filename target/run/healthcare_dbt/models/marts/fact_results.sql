
  
    
    

    create  table
      "healthcare_lab"."main"."fact_results__dbt_tmp"
  
    as (
      

SELECT
    product,
    lot_description,
    site,
    join_id,
    lot,
    category,
    result_value AS entry,
    units,
    result_captured_date,

    CURRENT_TIMESTAMP AS edl_inrt_dttm,
    CURRENT_TIMESTAMP AS edl_last_modf_dttm

FROM "healthcare_lab"."main"."int_final"
    );
  
  