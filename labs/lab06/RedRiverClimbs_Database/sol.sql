/*
SELECT climber_handle
  FROM climbers;
*/

/*
SELECT climb_name, climb_bolts, group_concat(climber_handle)
  FROM climbs
       INNER JOIN sport_climbs
       ON (climbs.climb_id = sport_climbs.climb_id)

       INNER JOIN first_ascents
       ON (climbs.climb_id = first_ascents.climb_id)

       INNER JOIN climbers
       ON (first_ascents.climber_id = climbers.climber_id)

    GROUP BY climb_name;
*/
/*
SELECT DISTINCT(climber_first_name), climber_last_name, region_name
  FROM climbers
       INNER JOIN developed_climbs
       ON (climbers.climber_id = developed_climbs.climber_id)

       INNER JOIN climbs
       ON (developed_climbs.climb_id = climbs.climb_id)

       INNER JOIN crags
       ON (climbs.crag_name = crags.crag_name)
WHERE crags.region_name = "Miller Fork";
*/

/*
SELECT DISTINCT(grade_str), COUNT(climb_id)
  FROM climbs
       RIGHT JOIN climb_grades
       ON (climbs.climb_grade = climb_grades.grade_id)
       
    GROUP BY grade_str
    ORDER BY grade_str;
*/
/*
SELECT DISTINCT(grade_str), COUNT(climb_id)
  FROM climb_grades
       LEFT JOIN climbs
       ON(climbs.climb_grade = climb_grades.grade_id)

    GROUP BY grade_str
    ORDER BY grade_str;
*/
/*
SELECT grade_str, group_concat(climb_name)
  FROM climbs
       INNER JOIN climb_grades
       ON (climbs.climb_grade = climb_grades.grade_id)
GROUP BY grade_str;
*/

SELECT grade_id
  FROM climbs
       INNER JOIN climb_grades
       ON(climbs.climb_grade = climb_grades.grade_id);