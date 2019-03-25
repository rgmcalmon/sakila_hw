USE sakila;

-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS `Actor Name`
FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- 2b
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT last_name, first_name, actor_id
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b
ALTER TABLE actor
DROP description;

-- 4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS `Count`
FROM actor
GROUP BY last_name
HAVING `Count` >= 2;

-- 4c
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT s.first_name, s.last_name, a.address
FROM staff AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id;

-- 6b
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff AS S
RIGHT JOIN payment AS p
ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08%'
GROUP BY p.staff_id;

-- 6c
SELECT f.title, COUNT(fa.actor_id)
FROM film AS f
INNER JOIN film_actor AS fa
ON f.film_id = fa.film_id
GROUP BY (f.film_id);

-- 6d
SELECT COUNT(film_id)
FROM inventory
WHERE film_id IN (
	SELECT film_id
	FROM film
	WHERE title = "Hunchback Impossible"
);

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) AS `Total Amount Paid`
FROM payment AS p
LEFT JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name, first_name;

-- 7a
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN (
	SELECT language_id
    FROM language
    WHERE name = "English"
);

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
	FROM film_actor
	WHERE film_id IN
		(SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
	)
) ORDER BY last_name,first_name;

-- 7c
SELECT cu.first_name, cu.last_name, co.country
FROM country co
	INNER JOIN city ci
		ON co.country_id = ci.country_id
	INNER JOIN address a
		ON ci.city_id = a.city_id
	INNER JOIN customer cu
		ON cu.address_id = a.address_id
WHERE co.country = "Canada"
ORDER BY cu.last_name, cu.first_name;

-- 7d
SELECT f.title, c.name as `Category`
FROM category c
	INNER JOIN film_category fi
		ON c.category_id = fi.category_id
	INNER JOIN film f
		ON fi.film_id = f.film_id
WHERE c.name = "Family";

-- 7e
SELECT f.title, COUNT(r.inventory_id) `Rentals`
FROM rental r
	INNER JOIN inventory i
		ON r.inventory_id = i.inventory_id
	INNER JOIN film f
		ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY `Rentals` DESC;

-- 7f
SELECT store.store_id, SUM(payment.amount) `Revenue ($)`
FROM payment
	INNER JOIN staff
		ON payment.staff_id = staff.staff_id
	INNER JOIN store
		ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- 7g
SELECT store.store_id, city.city, country.country
FROM country
	INNER JOIN city
		ON city.country_id = country.country_id
	INNER JOIN address
		ON address.city_id = city.city_id
	INNER JOIN store
		ON store.address_id = address.address_id;
        
-- 7h
SELECT category.name, SUM(payment.amount) `Gross Revenue`
FROM category
	INNER JOIN film_category
		ON category.category_id = film_category.category_id
	INNER JOIN inventory
		ON film_category.film_id = inventory.film_id
	INNER JOIN rental
		ON inventory.inventory_id = rental.inventory_id
	INNER JOIN payment
		ON rental.rental_id = payment.rental_id
GROUP BY category.category_id
ORDER BY `Gross Revenue` DESC
LIMIT 5;
        
-- 8a
CREATE VIEW top_five_genres
AS SELECT category.name, SUM(payment.amount) `Gross Revenue`
FROM category
	INNER JOIN film_category
		ON category.category_id = film_category.category_id
	INNER JOIN inventory
		ON film_category.film_id = inventory.film_id
	INNER JOIN rental
		ON inventory.inventory_id = rental.inventory_id
	INNER JOIN payment
		ON rental.rental_id = payment.rental_id
GROUP BY category.category_id
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8b
SELECT *
FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;