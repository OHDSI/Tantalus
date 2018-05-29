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
SELECT '1.01' AS test_id,
	'Old and new vocabulary version' AS test_description,
	'vocabulary' AS vocabulary_table,
	0 AS concept_id,
	'' AS concept_name,
	new_vocabulary.vocabulary_id AS vocabulary_id,
	'vocabulary' AS domain_id,
	old_vocabulary.vocabulary_version AS old_value,
	new_vocabulary.vocabulary_version AS new_value
INTO @result_temp_table
FROM @old_vocabulary_database_schema.vocabulary old_vocabulary
INNER JOIN @new_vocabulary_database_schema.vocabulary new_vocabulary
	ON old_vocabulary.vocabulary_id = new_vocabulary.vocabulary_id
WHERE LOWER(old_vocabulary.vocabulary_id) = 'none';
