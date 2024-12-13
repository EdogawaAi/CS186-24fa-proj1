-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  -- SELECT 1 -- replace this line
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE '% %'
  ORDER BY namefirst, namelast ASC
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear ASC
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count
  FROM people
  GROUP BY birthyear
  HAVING AVG(height) > 70
  ORDER BY birthyear ASC
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT p.namefirst, p.namelast, p.playerid, h.yearid
  FROM people p
  JOIN HallOfFame h ON p.playerid = h.playerid
  WHERE h.inducted = 'Y'
  ORDER BY h.yearid DESC, p.playerid ASC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  -- SELECT 1, 1, 1, 1, 1 -- replace this line
  SELECT p.namefirst, p.namelast, p.playerid, s.schoolid, h.yearid
  FROM people p
  JOIN collegeplaying s ON p.playerid = s.playerid
  JOIN HallOfFame h ON p.playerid = h.playerid
  JOIN schools sc ON s.schoolid = sc.schoolid
  WHERE sc.schoolstate = 'CA' AND h.inducted = 'Y'
  ORDER BY h.yearid DESC, p.playerid ASC, s.schoolid ASC
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT p.playerid, p.namefirst, p.namelast, s.schoolid
  FROM people p
  LEFT JOIN HallOfFame h ON p.playerid = h.playerid
  LEFT JOIN collegeplaying s ON p.playerid = s.playerid
  LEFT JOIN schools sc ON s.schoolid = sc.schoolid
  WHERE h.inducted = 'Y'
  ORDER BY p.playerid DESC, s.schoolid ASC
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  -- SELECT 1, 1, 1, 1, 1 -- replace this line
  SELECT b.playerid, p.namefirst, p.namelast, b.yearid, CAST((b.H - b.H2B - b.H3B - b.HR + 2 * b.H2B + 3 * b.H3B + 4 * b.HR) AS FLOAT) / b.AB AS slg
  FROM batting b
  JOIN people p ON b.playerid = p.playerid
  WHERE b.AB > 50
  ORDER BY slg DESC, b.playerid ASC, b.yearid ASC
  LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT b.playerid, p.namefirst, p.namelast, CAST((SUM(b.H) - SUM(b.H2B) - SUM(b.H3B) - SUM(b.HR) + 2 * SUM(b.H2B) + 3 * SUM(b.H3B) + 4 * SUM(b.HR)) AS FLOAT) / SUM(b.AB) AS lslg
  FROM batting b
  JOIN people p ON b.playerid = p.playerid
  GROUP BY b.playerid
  HAVING SUM(b.AB) > 50
  ORDER BY lslg DESC, b.playerid ASC
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT p.namefirst, p.namelast, CAST((SUM(b.H) - SUM(b.H2B) - SUM(b.H3B) - SUM(b.HR) + 2 * SUM(b.H2B) + 3 * SUM(b.H3B) + 4 * SUM(b.HR)) AS FLOAT) / SUM(b.AB) AS lslg
  FROM batting b
  JOIN people p ON b.playerid = p.playerid
  GROUP BY b.playerid
  HAVING SUM(b.AB) > 50 AND CAST((SUM(b.H) - SUM(b.H2B) - SUM(b.H3B) - SUM(b.HR) + 2 * SUM(b.H2B) + 3 * SUM(b.H3B) + 4 * SUM(b.HR)) AS FLOAT) / SUM(b.AB) > 
  (SELECT CAST((SUM(H) - SUM(H2B) - SUM(H3B) - SUM(HR) + 2 * SUM(H2B) + 3 * SUM(H3B) + 4 * SUM(HR)) AS FLOAT) / SUM(AB) FROM batting b WHERE b.playerid = 'mayswi01')
  ORDER BY lslg DESC, p.namefirst ASC, p.namelast ASC
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT yearid, MIN(salary), MAX(salary), AVG(salary)
  FROM salaries
  GROUP BY yearid
  ORDER BY yearid ASC
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  WITH salary_bins AS (
    SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary
    FROM salaries
    WHERE yearid = 2016
  ),
  bin_ranges AS (
    SELECT binid, min_salary + binid * (max_salary - min_salary) / 10 AS low, 
    CASE
      WHEN binid = 9 THEN max_salary
      ELSE min_salary + (binid + 1) * (max_salary - min_salary) / 10
    END AS high
    FROM binids, salary_bins
  )
  SELECT b.binid, b.low, b.high, COUNT(s.salary) AS count
  FROM bin_ranges b
  LEFT JOIN salaries s ON s.yearid = 2016 AND s.salary >= b.low AND (s.salary < b.high OR (b.binid = 9 AND s.salary = b.high))
  GROUP BY b.binid, b.low, b.high
  ORDER BY b.binid ASC
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  WITH yearly_salaries AS (
    SELECT yearid, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS avg_salary
    FROM salaries
    GROUP BY yearid
  ),
  year_diffs AS (
    SELECT y1.yearid, y1.min_salary - y0.min_salary AS mindiff, y1.max_salary - y0.max_salary AS maxdiff, y1.avg_salary - y0.avg_salary AS avgdiff
    FROM yearly_salaries y1
    JOIN yearly_salaries y0 ON y1.yearid = y0.yearid + 1
  )
  SELECT yearid, mindiff, maxdiff, ROUND(avgdiff, 4) AS avgdiff
  FROM year_diffs
  ORDER BY yearid ASC
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  -- SELECT 1, 1, 1, 1, 1 -- replace this line
  WITH max_salaries AS (
    SELECT yearid, MAX(salary) AS max_salary
    FROM salaries
    WHERE yearid IN (2000, 2001)
    GROUP BY yearid
  )
  SELECT s.playerid, p.namefirst, p.namelast, s.salary, s.yearid
  FROM salaries s
  JOIN people p ON s.playerid = p.playerid
  JOIN max_salaries m ON s.yearid = m.yearid AND s.salary = m.max_salary
  WHERE s.yearid IN (2000, 2001)
  ORDER BY s.playerid ASC, s.yearid ASC
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  -- SELECT 1, 1 -- replace this line
  WITH team_salaries AS (
    SELECT a.teamid, s.salary
    FROM allstarfull a
    JOIN salaries s ON a.playerid = s.playerid AND a.yearid = s.yearid
    WHERE s.yearid = 2016
  ),
  team_salary_diff AS (
    SELECT teamid, CASE WHEN COUNT(salary) > 1 THEN MAX(salary) - MIN(salary) ELSE 0 END AS diffAvg
    FROM team_salaries
    GROUP BY teamid
  )
  SELECT teamid AS team, ROUND(diffAvg, 4) AS diffAvg
  FROM team_salary_diff
  ORDER BY team ASC
;

