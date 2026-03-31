
  
  create view "healthcare_lab"."main"."stg_sample__dbt_tmp" as (
    SELECT *
FROM "healthcare_lab"."main"."sample"
  );
