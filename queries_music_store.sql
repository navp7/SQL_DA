use music_store;

-- Q1: Who is the senior most employee by age?

SELECT first_name , last_name, TIMESTAMPDIFF(YEAR,birthdate,NOW()) AS age
FROM employee
ORDER BY age DESC;

-- Q2: Which countries have the most Invoices?

SELECT billing_country, COUNT(*) AS Total
FROM invoice
GROUP BY billing_country
ORDER BY Total DESC;


-- Q3: What are top 3 values of total invoice?

SELECT DISTINCT total
FROM invoice
ORDER BY total DESC;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city 
we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT billing_city, SUM(total) AS Total_Sum
FROM invoice
GROUP BY billing_city
ORDER BY Total_Sum DESC
LIMIT 5;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id, customer.first_name , customer.last_name, SUM(invoice.total) as invoice_sum
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY invoice_sum DESC
LIMIT 1;


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT customer.email , customer.first_name ,customer.last_name, genre.name as genre_name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
JOIN invoice_line ON track.track_id = invoice_line.track_id
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
WHERE genre.name LIKE "Rock"
ORDER BY customer.email ASC;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name, COUNT(track_id) AS Number_of_tracks
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON track.album_id = album.album_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE "Rock"
GROUP BY artist.artist_id
ORDER BY Number_of_tracks DESC
LIMIT 10;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs
listed first. */


SELECT  name AS Track_name, milliseconds AS Song_Length
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) 
						FROM track)
ORDER BY milliseconds DESC;



/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH most_selled_artist AS(
SELECT artist.artist_id, artist.name, SUM(invoice_line.unit_price*invoice_line.quantity) As Total_selling
FROM invoice_line
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY 1,2
ORDER BY 3 DESC
)
SELECT customer.customer_id, customer.first_name, customer.last_name, most_selled_artist.name, 
SUM(invoice_line.unit_price*invoice_line.quantity) As Total_selling
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON album.album_id = track.album_id
JOIN most_selled_artist ON album.artist_id = most_selled_artist.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;



/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */


WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;


/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH max_sale AS(
SELECT customer.customer_id, customer.first_name, customer.last_name, invoice.billing_country, SUM(invoice.total) AS Total,
ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) AS row_num
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY 1,4
ORDER BY 4 ASC)
SELECT * FROM max_sale WHERE row_num = 1;










