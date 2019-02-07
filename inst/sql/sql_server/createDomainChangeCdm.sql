IF OBJECT_ID('@target_database_schema.@domain_change_cdm_table') IS NOT NULL
    DROP TABLE @target_database_schema.@domain_change_cdm_table;

CREATE TABLE @target_database_schema.@domain_change_cdm_table (
    [db] varchar(255),
    [table_name] varchar(255),
    [concept_id] int,
    [old_domain_id] varchar(255),
    [new_domain_id] varchar(255),
    [concept_name] varchar (255),
    [person_count] bigint
)
WITH (DISTRIBUTION = REPLICATE);
