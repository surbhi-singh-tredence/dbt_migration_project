
  
  create view "healthcare_lab"."main"."stg_lot__dbt_tmp" as (
    SELECT *
FROM "healthcare_lab"."main"."lot"
  );
