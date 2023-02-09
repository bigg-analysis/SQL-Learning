-- Question 1 --
SELECT * FROM vb_users
WHERE user_zip_code LIKE '13%'
GO

-- Question 2 --
SELECT s.user_firstname as 'First Name', s.user_lastname as 'Last Name', s.user_email as 'Email', s.user_zip_code as 'Zip Code',
z.zip_city as 'City'
FROM vb_zip_codes z
JOIN vb_users s on s.user_zip_code = z.zip_code
ORDER BY z.zip_city, s.user_lastname, s.user_firstname
GO

-- Question 3 --
SELECT item_id as 'Item ID', item_name as 'Item Name', item_type as 'Item Type', item_reserve as 'Reserves' FROM vb_items
WHERE item_sold = 0 and item_reserve >= 250
ORDER BY item_reserve DESC
GO

-- Question 4 --
SELECT item_id as 'Item ID', item_name as 'Item Name', item_type as 'Item Type', item_reserve as 'Reserves', 
    CASE WHEN item_reserve >= 250 then 'High-Priced'
    WHEN item_reserve <= 50 then 'Low-Priced'
    ELSE 'Average-Priced'
    END AS 'Price Category'
FROM vb_items
WHERE item_type != 'All Other'
ORDER BY item_reserve, item_name
GO

-- Question 5 --
SELECT i.item_id as 'Item ID', b.bid_id as 'Bid ID', s.user_firstname + ' ' + s.user_lastname as 'Bidder Name',
s.user_email as 'Bidder Email', b.bid_datetime as 'Bid Date & Time', b.bid_amount as 'Bid Amount', b.bid_status as 'Bid Status'
FROM vb_items i
JOIN vb_bids b on b.bid_item_id = i.item_id
JOIN vb_users s on s.user_id = b.bid_user_id
WHERE b.bid_status = 'ok'
ORDER BY b.bid_datetime DESC

-- Question 6 -- 
SELECT i.item_id as 'Item ID', b.bid_id as 'Bid ID', s.user_firstname as 'Bidder First Name', s.user_lastname as 'Bidder Last Name',
s.user_email as 'Bidder Email', b.bid_datetime as 'Bid Date & Time', b.bid_amount as 'Bid Amount', b.bid_status as 'Bid Status'
FROM vb_items i
JOIN vb_bids b on b.bid_item_id = i.item_id
JOIN vb_users s on s.user_id = b.bid_user_id
WHERE b.bid_status != 'ok' and b.bid_status != 'item_seller'
ORDER BY s.user_lastname, s.user_firstname, b.bid_datetime DESC

-- Question 7 --
-- Produce a report of items that do not contain a bid. Include the item ID, item name, item type, seller’s name, and item reserve. --
SELECT i.item_id as 'Item ID', i.item_name as 'Item Name', i.item_type as 'Item Type', s.user_firstname + ' ' + s.user_lastname as 'Seller ID',
    i.item_reserve as 'Item Reserve Price'
FROM vb_users s
JOIN vb_items i on i.item_seller_user_id  = s.user_id
WHERE i.item_id NOT IN (SELECT bid_item_id FROM vb_bids)

-- Question 8 --
-- Produce a list of seller ratings. Include the name of the user who gave the rating, the name of the user the rating was for, 
-- the rating value, and rating comment. Include ratings of only sellers.
SELECT r.rating_id as 'Rating ID', sell.user_firstname + ' ' + sell.user_lastname as 'Rating Receiver',  r.rating_value as 'Rating Value', buy.user_firstname + ' ' + buy.user_lastname as 'Critic Name',
    r.rating_comment as 'Rating Comment'
FROM vb_user_ratings r
JOIN vb_users sell on sell.user_id = r.rating_for_user_id
JOIN vb_users buy on  buy.user_id = r.rating_by_user_id
WHERE r.rating_astype = 'Seller'

-- Question 9 --
-- For items that were sold, generate a report that includes the locations (city and state) of the buyer and seller. 
-- Include item ID, item name, item type item sold amount, name of seller, seller’s city/state, name of buyer, and the buyer’s city/state.
SELECT i.item_id as 'Item ID', i.item_name as 'Item Sold', i.item_type as 'Item Type', i.item_soldamount as 'Price Sold At',
    sell.user_firstname + ' ' + sell.user_lastname as 'Seller Name', sz.zip_city + ', ' + sz.zip_state as 'Seller Location',
    buy.user_firstname + ' ' + buy.user_lastname as ' Buyer Name', bz.zip_city + ', ' + bz.zip_state as 'Buyer Location'
FROM vb_items i
JOIN vb_users sell on sell.user_id = i.item_seller_user_id
JOIN vb_zip_codes sz on sz.zip_code = sell.user_zip_code
JOIN vb_users buy on buy.user_id = i.item_buyer_user_id
JOIN vb_zip_codes bz on bz.zip_code = buy.user_zip_code
WHERE i.item_sold = 1

-- Question 10 --
SELECT inactive.user_id as 'Inactive User ID', inactive.user_firstname + ' ' + inactive.user_lastname as 'User Name', inactive.user_email 'E-mail'
FROM vb_users inactive
WHERE inactive.user_id NOT IN 
    (SELECT item_seller_user_id FROM vb_items) AND
    inactive.user_id NOT IN (SELECT item_buyer_user_id FROM vb_items) AND
    inactive.user_id NOT IN (SELECT bid_user_id FROM vb_bids)

SELECT user_id FROM vb_users
WHERE user_id in (SELECT item_seller_user_id FROM vb_items) OR
      user_id in (SELECT item_buyer_user_id FROM vb_items) OR
      user_id in (SELECT bid_user_id FROM vb_bids)

SELECT user_id from vb_users