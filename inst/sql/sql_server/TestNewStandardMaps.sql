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

SELECT '99.01' AS test_id,
	'Source concepts with new standard mappings, including 0' AS test_description,
	'concept_relationship' AS vocabulary_table,
	source_concept_id AS concept_id,
	source_code_description AS concept_name,
	source_vocabulary_id AS vocabulary_id,
	source_domain_id AS domain_id,
	cast(old_target_concept_id as varchar) as old_value,
	cast(new_target_concept_id as varchar) as new_value
INTO @result_temp_table
FROM (
	SELECT o.unique_id,
			o.source_code,
			o.source_code_description,
			o.source_concept_id,
			o.source_vocabulary_id,
			o.source_domain_id,
			o.old_target_concept_id,
			o.map_exists_in_new_vocab,
			CASE
				WHEN O.SOURCE_CONCEPT_ID IN (SELECT CONCEPT_ID FROM @new_vocabulary_database_schema.CONCEPT WHERE INVALID_REASON IS NULL)
					THEN 1
			ELSE 0 END AS SOURCE_CODE_IN_NEW_VOCAB,
			CASE
				WHEN O.OLD_TARGET_CONCEPT_ID IN (SELECT CONCEPT_ID FROM @new_vocabulary_database_schema.CONCEPT WHERE INVALID_REASON IS NOT NULL)
					THEN 1
			ELSE 0 END AS OLD_TARGET_DEPRECATED,
			CASE
				WHEN N.TARGET_CONCEPT_ID IS NULL
					THEN 0
			ELSE N.TARGET_CONCEPT_ID END AS NEW_TARGET_CONCEPT_ID,
			TARGET_DOMAIN_ID AS NEW_TARGET_DOMAIN_ID,
			CASE
				WHEN N.UNIQUE_ID IN (SELECT UNIQUE_ID FROM #SourceToStandardOld)
					THEN 1
			ELSE 0 END AS NEW_MAP_EXISTS_IN_OLD_VOCAB,
			ROW_NUMBER() OVER (PARTITION BY O.UNIQUE_ID ORDER BY O.UNIQUE_ID) AS RN
	FROM(
	SELECT o.unique_id,
			o.source_code,
			o.source_code_description,
			o.source_concept_id,
			o.source_vocabulary_id,
			o.source_domain_id,
			O.TARGET_CONCEPT_ID AS OLD_TARGET_CONCEPT_ID,
			CASE
				WHEN O.UNIQUE_ID IN (
										SELECT UNIQUE_ID FROM #SourceToStandardNew
										)
				THEN 1
			ELSE 0
			END AS MAP_EXISTS_IN_NEW_VOCAB
	FROM #SourceToStandardOld O
	WHERE SOURCE_VOCABULARY_ID NOT LIKE 'JNJ%' AND SOURCE_CONCEPT_ID <> 0
	) O
	LEFT JOIN #SourceToStandardNew N
		ON O.SOURCE_CONCEPT_ID = N.SOURCE_CONCEPT_ID
	WHERE O.MAP_EXISTS_IN_NEW_VOCAB = 0
) A

--@old_vocabulary_database_schema

;
