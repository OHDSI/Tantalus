/************************************************************************
Copyright 2018 Observational Health Data Sciences and Informatics

This file is part of VocabCompare

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
************************************************************************/

SELECT *
INTO #SourceToStandardNew
FROM (

	SELECT cast(c.concept_id as varchar)+'-'+cast(c1.concept_id as varchar) as UNIQUE_ID, c.concept_code AS SOURCE_CODE, c.concept_id AS SOURCE_CONCEPT_ID, c.concept_name AS SOURCE_CODE_DESCRIPTION,
			c.vocabulary_id AS SOURCE_VOCABULARY_ID, c.domain_id AS SOURCE_DOMAIN_ID, c.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID,
			c.VALID_START_DATE AS SOURCE_VALID_START_DATE, c.VALID_END_DATE AS SOURCE_VALID_END_DATE, c.INVALID_REASON AS SOURCE_INVALID_REASON,
			c1.concept_id AS TARGET_CONCEPT_ID, c1.concept_name AS TARGET_CONCEPT_NAME, c1.VOCABULARY_ID AS TARGET_VOCABULARY_ID,
			c1.domain_id AS TARGET_DOMAIN_ID, c1.concept_class_id AS TARGET_CONCEPT_CLASS_ID,c1.INVALID_REASON AS TARGET_INVALID_REASON,
			c1.standard_concept AS TARGET_STANDARD_CONCEPT
	FROM @new_vocabulary_database_schema.CONCEPT C
		JOIN @new_vocabulary_database_schema.CONCEPT_RELATIONSHIP CR
			ON C.CONCEPT_ID = CR.CONCEPT_ID_1
			AND CR.invalid_reason IS NULL
			AND lower(cr.relationship_id) = 'maps to'
		JOIN @new_vocabulary_database_schema.CONCEPT C1
			ON CR.CONCEPT_ID_2 = C1.CONCEPT_ID
			AND C1.INVALID_REASON IS NULL
	UNION
	SELECT cast(SOURCE_CONCEPT_ID as varchar)+'-'+cast(TARGET_CONCEPT_ID as varchar) as UNIQUE_ID, source_code, SOURCE_CONCEPT_ID, SOURCE_CODE_DESCRIPTION, source_vocabulary_id, c1.domain_id AS SOURCE_DOMAIN_ID,
			c2.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID, c1.VALID_START_DATE AS SOURCE_VALID_START_DATE,
			c1.VALID_END_DATE AS SOURCE_VALID_END_DATE, stcm.INVALID_REASON AS SOURCE_INVALID_REASON,
			target_concept_id, c2.CONCEPT_NAME AS TARGET_CONCEPT_NAME, target_vocabulary_id, c2.domain_id AS TARGET_DOMAIN_ID,
			c2.concept_class_id AS TARGET_CONCEPT_CLASS_ID,c2.INVALID_REASON AS TARGET_INVALID_REASON,
			c2.standard_concept AS TARGET_STANDARD_CONCEPT
	FROM @new_vocabulary_database_schema.source_to_concept_map stcm
		LEFT OUTER JOIN @new_vocabulary_database_schema.CONCEPT c1
			ON c1.concept_id = stcm.source_concept_id
		LEFT OUTER JOIN @new_vocabulary_database_schema.CONCEPT c2
			ON c2.CONCEPT_ID = stcm.target_concept_id
	WHERE stcm.INVALID_REASON IS NULL
) STSN;
--@old_vocabulary_database_schema
