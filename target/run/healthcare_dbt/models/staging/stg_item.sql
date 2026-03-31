
  
  create view "healthcare_lab"."main"."stg_item__dbt_tmp" as (
    SELECT *
FROM "healthcare_lab"."main"."item"
  );
