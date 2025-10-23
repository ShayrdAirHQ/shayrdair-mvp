WITH table_info AS (
  SELECT 
    t.table_name,
    obj_description((t.table_schema||'.'||t.table_name)::regclass, 'pg_class') as table_comment,
    c.column_name,
    c.data_type,
    c.is_nullable,
    c.column_default,
    col_description((t.table_schema||'.'||t.table_name)::regclass, c.ordinal_position) as column_comment
  FROM information_schema.tables t
  JOIN information_schema.columns c 
    ON t.table_name = c.table_name 
    AND t.table_schema = c.table_schema
  WHERE t.table_schema = 'public'
    AND t.table_type = 'BASE TABLE'
  ORDER BY t.table_name, c.ordinal_position
),
constraint_info AS (
  SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
  FROM information_schema.table_constraints tc
  LEFT JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
  LEFT JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
  WHERE tc.table_schema = 'public'
)
SELECT 
  '## ' || ti.table_name || E'\n' ||
  string_agg(
    '- ' || ti.column_name || 
    ' (' || ti.data_type || 
    CASE WHEN ci_pk.constraint_type = 'PRIMARY KEY' THEN ', pk' ELSE '' END ||
    CASE WHEN ci_fk.constraint_type = 'FOREIGN KEY' THEN ', fk → ' || ci_fk.foreign_table_name || '.' || ci_fk.foreign_column_name ELSE '' END ||
    CASE WHEN ti.is_nullable = 'NO' THEN ', not null' ELSE '' END ||
    CASE WHEN ti.column_default IS NOT NULL THEN ', default ' || ti.column_default ELSE '' END ||
    ')',
    E'\n'
    ORDER BY ti.column_name
  ) || E'\n' AS table_markdown
FROM table_info ti
LEFT JOIN constraint_info ci_pk 
  ON ti.table_name = ci_pk.table_name 
  AND ti.column_name = ci_pk.column_name 
  AND ci_pk.constraint_type = 'PRIMARY KEY'
LEFT JOIN constraint_info ci_fk 
  ON ti.table_name = ci_fk.table_name 
  AND ti.column_name = ci_fk.column_name 
  AND ci_fk.constraint_type = 'FOREIGN KEY'
GROUP BY ti.table_name
ORDER BY ti.table_name;
