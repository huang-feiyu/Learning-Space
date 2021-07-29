SELECT work.name,
    work_type.name
FROM work 
    INNER JOIN (
        SELECT max(length(work.name)) AS max_length,
            work.type AS type
        FROM work
        GROUP BY work.type
    ) AS newtable on newtable.max_length = length(work.name) 
    AND work.type = newtable.type
    INNER JOIN work_type on work.type = work_type.id
ORDER BY work.type ASC,
    work.name ASC;