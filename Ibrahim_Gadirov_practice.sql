SET search_path TO public;

/* Task1*/
select c.name as category_name,count(*) as movie_count
from category c
join film_category fc on c.category_id=fc.category_id 
group by category_name
order by movie_count desc;

/* Task2 */
select a.first_name || ' ' ||  a.last_name as actor_name,count(*) as rental_count
from actor a 
join film_actor fa on a.actor_id =fa.actor_id
join film f on fa.film_id=f.film_id
join inventory i on f.film_id=i.film_id 
join rental r on r.inventory_id=i.inventory_id 
group by actor_name
order by rental_count desc 
limit 10;

/* Task 3*/
select c.name as category_name,SUM(p.amount) as total_spent
from category c
join film_category fc on c.category_id = fc.category_id 
join inventory i on i.film_id=fc.film_id
join rental r on r.inventory_id=i.inventory_id
join payment p on p.rental_id=r.rental_id
group by category_name
order by total_spent
limit 1;

/* Task 4 */
select f.title as movie_name from film f 
left join inventory i on f.film_id =i.film_id 
where i.inventory_id is null;

/* Task 5 */
select a.first_name || ' ' || a.last_name as full_name,
    count(*) as movie_count
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on f.film_id = fa.film_id
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
where c.name = 'Children'
group by full_name
order by movie_count desc
fetch first 3 rows with ties;

/* Task 6 */
select ci.city,
count(case when c.active = 1 then 1 end ) as active_customes,
count(case when c.active = 0 then 1 end) as inactive_customers
from customer c
join address a on a.address_id=c.address_id
join city ci on ci.city_id=a.city_id
group by ci.city
order by inactive_customers desc;

/* Task 7 */
select distinct  on (ci.city) ci.city as city, cat.name as category,SUM(r.return_date - r.rental_date) as total_rental
from customer cu
join address a on a.address_id=cu.address_id
join city ci on ci.city_id = a.city_id
join rental r on cu.customer_id=r.customer_id
join inventory i on i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
join film_category fc on fc.film_id=f.film_id
join category cat on cat.category_id=fc.category_id
where r.return_date is not null and ( ci.city ilike 'a%' or ci.city ilike '%-%')
group by city,category
ORDER BY ci.city, total_rental DESC;
