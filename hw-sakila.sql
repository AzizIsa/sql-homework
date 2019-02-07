-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name," ", last_name) as Actor_Name from sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name  from sakila.actor where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select *  from sakila.actor where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select *  from sakila.actor where last_name like '%LI%' ORDER BY last_name ASC, first_name ASC;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select * from sakila.country where country  in ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table sakila.actor add column description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table sakila.actor drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) from sakila.actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) from sakila.actor group by last_name having count(last_name) > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from sakila.actor where last_name='WILLIAMS' and first_name ='GROUCHO';
UPDATE sakila.actor SET first_name = 'HARPO' WHERE last_name='WILLIAMS' and first_name ='GROUCHO';
select * from sakila.actor where last_name='WILLIAMS' and first_name ='HARPO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE sakila.actor SET first_name = 'GROUCHO' WHERE first_name ='HARPO';
select * from sakila.actor where last_name='WILLIAMS' and first_name ='GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table sakila.address;

-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select st.first_name, st.last_name, ad.address from sakila.staff st join sakila.address ad on st.address_id=ad.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select sum(pay.amount), st.first_name from sakila.payment pay join sakila.staff st on st.staff_id = pay.staff_id group by st.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from sakila.film_actor;
select  act.film_id, f.title, count(act.actor_id) from sakila.film_actor act inner join sakila.film f on act.film_id= f.film_id group by film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(title) from sakila.film where title='Hunchback Impossible';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

select c.last_name, c.first_name, sum(pay.amount) from sakila.customer c join sakila.payment pay on c.customer_id =pay.customer_id group by c.customer_id order by c.last_name;

select * from sakila.payment;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from sakila.film where title like "Q%" or title like "K%" and language_id in (select language_id from sakila.language where name ="English");


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select first_name, last_name from sakila.actor where actor_id in (select actor_id from sakila.film_actor where film_id in (select film_id from sakila.film where title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select c.first_name, c.last_name, c.email, co.country from sakila.customer c 
inner join sakila.address ad on c.address_id = ad.address_id 
inner join sakila.city ci on ad.city_id=ci.city_id 
inner join sakila.country co on ci.country_id=co.country_id 
where country="Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.title, c.name from sakila.film f 
join sakila.film_category fc using(film_id) 
join sakila.category c using(category_id) 
where name="Family";

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(r.inventory_id)  from sakila.film f
join sakila.inventory inv using(film_id)
join sakila.rental r using(inventory_id)
group by f.title 
order by count(r.inventory_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) from sakila.store s
join sakila.inventory inv using(store_id) 
join sakila.rental r using(inventory_id)
join sakila.payment p using(rental_id) group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

select s.store_id, c.city, co.country from sakila.store s
join sakila.address a using(address_id)
join sakila.city c using(city_id)
join sakila.country co using(country_id)
group by s.store_id;

-- 7h. List the top five genres(category) in gross revenue in descending order. (Hint: you may need to use the following tables:
-- category, film_category, inventory, payment, and rental.)
select cat.name, sum(pay.amount) from sakila.category cat
join sakila.film_category using(category_id)
join sakila.inventory using(film_id)
join sakila.rental using(inventory_id)
join sakila.payment pay using(rental_id)
group by cat.name order by sum(pay.amount) desc limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5genres AS
select cat.name, sum(pay.amount) from sakila.category cat
join sakila.film_category using(category_id)
join sakila.inventory using(film_id)
join sakila.rental using(inventory_id)
join sakila.payment pay using(rental_id)
group by cat.name order by sum(pay.amount) desc limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_5genres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_5genres;