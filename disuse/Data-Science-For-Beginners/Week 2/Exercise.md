---
title:       Exercise
author:      Huang
date:        21.11.08
description: 课程练习备份
---

### Relational Database
* [Pre Quiz](https://red-water-0103e7a0f.azurestaticapps.net/quiz/8)
* [Post Quiz](https://red-water-0103e7a0f.azurestaticapps.net/quiz/9)
* Assignment

```bash
sqlite3 ../Resources/airports.db
```

```sql
# Problem 1: all city names in the Cities table
SELECT city
FROM Cities;

# Problem 2: all cities in Ireland in the Cities table
SELECT city
FROM Cities
WHERE country="Ireland";

# Problem 3: all airport names with their city and country
SELECT Airports.name AS name, Cities.city AS city, Cities.country AS country
FROM
  Airports JOIN Cities
  ON Airports.city_id=Cities.id;

# Problem 4: all airports in London, United Kingdom
SELECT Airports.name
FROM
  Airports JOIN Cities
  ON Airports.city_id=Cities.id
WHERE Cities.country="United Kingdom" AND Cities.city="London";
```


