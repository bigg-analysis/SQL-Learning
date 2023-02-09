-- Brandon Liunoras HW 5 Query --

-- Question 1 --
-- How many item types are there? Perform an analysis of each item type. 
-- For each item type, provide the count of items in that type and the 
-- minimum, average, and maximum item reserve prices for that type. Sort the output by item type. 


SELECT COUNT(DISTINCT item_type) as "Number of Item Types" FROM vb_items


SELECT item_type as "Item Type", count(item_type) as "Item Type Count", min(item_reserve) as "Minimum Reserve Price" , 
round(avg(item_reserve),2) as "Average Reserve Price", max(item_reserve) as "Maximum Reserve Price"
FROM vb_items 
GROUP BY item_type
ORDER BY item_type
GO

-- Question 2 --
-- Perform an analysis of each item in the “Antiques” and “Collectables” item types. 
-- For each item, display the name, item type, and item reserve. Include the minimum, maximum, and average 
-- item reserve over each item type so that the current item reserve can be compared to these values.

SELECT item_type as "Item Type", count(item_type) as "Item Type Count", min(item_reserve) as "Minimum Reserve Price" , round(avg(item_reserve),2) as "Average Reserve Price",
max(item_reserve) as "Maximum Reserve Price"
FROM vb_items
WHERE item_type = 'Antiques' OR item_type = 'Collectables'
GROUP BY item_type
ORDER BY item_type
GO

-- Question 3 --
-- Write a query to include the names, counts (number of ratings), and average seller ratings (as a decimal) of users. 
-- For reference, User Carrie Dababbi has four seller ratings and an average rating of 4.75. 

-- Question 4 --
-- Create a list of “Collectable” item types with more than one bid. 
-- Include the name of the item and the number of bids, making sure the item with the most bids appear first.

SELECT i.item_name as "Item Name", count(b.bid_item_id) as "Number of Bids" 
FROM vb_items i
JOIN vb_bids b on b.bid_item_id = i.item_id
GROUP BY i.item_name
HAVING count(i.item_name) > 1

-- Question 5 --
-- Generate a valid bidding history for any given item of your choice. 
-- Display the item ID, item name, a number representing the order the bid was placed, the bid amount, and the bidder’s name. 
-- Here’s an example showing the first three bids on item 11: 

SELECT i.item_id as "Item ID", i.item_name as "Item Name", ROW_NUMBER() OVER(ORDER BY i.item_name) as "Bid Number",
b.bid_amount as "Bid Amount", u.user_firstname + ' ' + u.user_lastname as "Bidder Name"
FROM vb_items i
JOIN vb_bids b on b.bid_item_id = i.item_id
JOIN vb_users u on u.user_id = b.bid_user_id
WHERE i.item_id = 11
ORDER BY b.bid_amount


SELECT * FROM vb_bids

