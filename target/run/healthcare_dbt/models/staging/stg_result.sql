
  
  create view "healthcare_lab"."main"."stg_result__dbt_tmp" as (
    SELECT *
FROM "healthcare_lab"."main"."result"
  );
