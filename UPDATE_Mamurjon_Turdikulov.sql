-- 1. Alter the rental duration and rental rates of the film
UPDATE film
SET rental_duration = 21, rental_rate = 9.99
WHERE film_id = (SELECT film_id FROM film WHERE title = 'The Conjuring');

-- 2. Alter any existing customer with at least 10 rental and payment records
UPDATE customer
SET first_name = 'Mamurjon',
    last_name = 'Turdikulov',
    address_id = (SELECT address_id FROM address LIMIT 1), -- Choose any existing address
    email = 'your_email@example.com',
    create_date = CURRENT_DATE()
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id, COUNT(rental_id) AS num_rentals
        FROM rental
        GROUP BY customer_id
        HAVING num_rentals >= 10
    ) AS rentals
    JOIN (
        SELECT customer_id, COUNT(payment_id) AS num_payments
        FROM payment
        GROUP BY customer_id
        HAVING num_payments >= 10
    ) AS payments ON rentals.customer_id = payments.customer_id
);