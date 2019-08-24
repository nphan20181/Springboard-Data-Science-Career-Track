/* Ngoc Phan - SQL Exercise */


/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) 
FROM Facilities
WHERE membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM Facilities
WHERE membercost > 0 AND membercost < (0.2 * monthlymaintenance)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
     ELSE 'cheap' END AS maintenance_cost
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, MAX(joindate)
FROM Members
WHERE firstname != 'GUEST' AND surname != 'GUEST'

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT fac.name, CONCAT(mem.firstname, ' ', mem.surname) AS member_name
FROM Bookings bk
JOIN Facilities fac ON fac.facid = bk.facid
JOIN Members mem ON mem.memid = bk.memid
GROUP BY member_name
ORDER BY member_name

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT fac.name, CONCAT(mem.firstname, ' ', mem.surname) AS member_name,
SUM(CASE WHEN mem.memid = 0 THEN fac.guestcost * bk.slots
     ELSE fac.membercost * bk.slots END) AS cost
FROM Bookings bk
JOIN Facilities fac ON fac.facid = bk.facid 
JOIN Members mem ON mem.memid = bk.memid 
WHERE bk.starttime LIKE '2012-09-14%'
GROUP BY fac.name, member_name
HAVING cost > 30
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT fac.name, CONCAT(mem.firstname, ' ', mem.surname) AS member_name,
SUM(CASE WHEN mem.memid = 0 THEN fac.guestcost * bk.slots
     ELSE fac.membercost * bk.slots END) AS cost
FROM Bookings bk
JOIN (SELECT * FROM Facilities) fac ON fac.facid = bk.facid
JOIN (SELECT * FROM Members) mem ON mem.memid = bk.memid
WHERE bk.starttime LIKE '2012-09-14%'
GROUP BY fac.name, member_name
HAVING cost > 30
ORDER BY cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT fac.name,
SUM(CASE WHEN bk.memid = 0 THEN fac.guestcost * bk.slots
     ELSE fac.membercost * bk.slots END) AS total_revenue
FROM Facilities fac
JOIN Bookings bk ON bk.facid = fac.facid
GROUP BY fac.name
HAVING total_revenue < 1000
ORDER BY total_revenue