IF OBJECT_ID('@target_database_schema.@new_maps_cdm_table') IS NOT NULL
    DROP TABLE @target_database_schema.@new_maps_cdm_table;

CREATE TABLE @target_database_schema.@new_maps_cdm_table (
    [db] varchar(255),
    [current_location] varchar(255),
    [source_code] varchar(255),
    [source_vocabulary_id] varchar(255),
    [source_concept_name] varchar(255),
    [new_target_concept_id] int,
    [new_domain_id] varchar(255),
    [current_concept_id] int,
    [person_count] bigint

)
WITH (DISTRIBUTION = REPLICATE);

