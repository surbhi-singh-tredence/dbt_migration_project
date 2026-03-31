
  
  create view "healthcare_lab"."main"."stg_test__dbt_tmp" as (
    SELECT *
FROM "healthcare_lab"."main"."test"
  );
