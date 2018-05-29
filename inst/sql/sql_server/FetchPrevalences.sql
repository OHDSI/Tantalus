SELECT person_count / (1.0 * population_size) AS prevalence,
  concept_id
INTO #prevalences
FROM (

SELECT condition_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.condition_occurrence
WHERE condition_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY condition_concept_id

UNION ALL
SELECT procedure_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.procedure_occurrence
WHERE procedure_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY procedure_concept_id

UNION ALL
SELECT drug_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.drug_exposure
WHERE drug_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY drug_concept_id

UNION ALL
SELECT device_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.device_exposure
WHERE device_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY device_concept_id

UNION ALL
SELECT cause_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.death
WHERE cause_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY cause_concept_id

UNION ALL
SELECT measurement_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.measurement
WHERE measurement_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY measurement_concept_id

UNION ALL
SELECT observation_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.observation
WHERE observation_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY observation_concept_id

UNION ALL
SELECT specimen_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.specimen
WHERE specimen_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY specimen_concept_id

UNION ALL
SELECT visit_concept_id AS concept_id, COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.visit_occurrence
WHERE visit_concept_id IN (
                SELECT concept_id FROM #concept_ids
)
GROUP BY visit_concept_id
) unions 
CROSS JOIN (
SELECT COUNT(*) AS population_size FROM @cdm_database_schema.person) overall;

