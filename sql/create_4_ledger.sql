-- SQL statements for creating all ledger-related CrateDig DB tables.
-- Copyright (c) 2025, Kevin Damm
-- All rights reserved.
-- MIT License:
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- github:kevindamm/cratedigdb/sql/create_4_ledger.sql

CREATE TABLE IF NOT EXISTS "OrderStatus" (
    "statusID"     INTEGER
      PRIMARY KEY
  , "status"       TEXT
      NOT NULL
  , "summary"      TEXT
);

-- 
-- Database TABLE and INDEX definitions for representing sale amounts and dates
-- (intended as a convenience for operational organization and tax accounting).
--
--   [----------]   N..1
--   | Listings |--------index[Inventory__User]
--   [----------]
--       |
--       |                *orderID
--       | N..N   [--------]        (enum)
--       '--------| Orders |--------[OrderStatus] 1..N
--                [--------]                   *----*[OrderUpdates]
--                 +buyer, seller FK(userID)   *--,    |
--                                                |    +index[Update__Order]
--                                                |    +index[Update__Timestamp]
--                                                |
--                                                |--*[OrderPurchases]
--                                                '--*[OrderTrades]
--
-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.
--

CREATE TABLE IF NOT EXISTS "Listings" (
  , "userID"          INTEGER
      NOT NULL          CHECK (userID <> 0)
      REFERENCES        UserProfiles (userID)
      ON DELETE         RESTRICT
      ON UPDATE         RESTRICT
  , "versionID"       INTEGER
      NOT NULL          CHECK (versionID <> 0)
      REFERENCES        ReleaseVersions (userID)
      ON DELETE         RESTRICT
      ON UPDATE         RESTRICT
  , "item"            INTEGER
      NOT NULL          DEFAULT 1
  
  , "price_low"       INTEGER
  , "price_high"      INTEGER
  , "price_currency"  TEXT  -- discogs currency abbreviation

  , "allow_offers"    BOOLEAN
      NOT NULL          DEFAULT FALSE
  , "date_opened"     TEXT  -- YYYY/MM/DD
      NOT NULL          DEFAULT CURRENT_DATE
  , "date_closed"     TEXT  -- YYYY/MM/DD
      -- if NULL, this listing is still available

  , FOREIGN KEY           ("userID", "versionID", "item")
    REFERENCES VinylItems ("userID", "versionID", "item")

  , PRIMARY KEY ("userID", "versionID", "item")
);

CREATE INDEX IF NOT EXISTS "Listing__User"
  ON Listings (userID)
  ;

CREATE INDEX IF NOT EXISTS "Listing__Version"
  ON Listings (versionID)
  ;

CREATE INDEX IF NOT EXISTS "Listing__Opened"
  ON Listings (date_opened)
  WHERE (date_closed IS NULL)
  ;


CREATE TABLE IF NOT EXISTS "Orders" (
    "orderID"        INTEGER
      PRIMARY KEY

  , "seller_userID"  INTEGER
      -- Only orders for known sellers are tracked.
      NOT NULL         -- usually it's the person running this service.
      REFERENCES       UserProfiles (userID)
      ON DELETE        CASCADE
  , "buyer_userID"   INTEGER
      NOT NULL         DEFAULT 0
      REFERENCES       UserProfiles (userID)
      ON DELETE        SET NULL

  -- This is the total price minus the trade value and reflects the most recent
  -- value.  It must be positive; otherwise buyer and seller are swapped.
  , "offer_price"     REAL
      NOT NULL          CHECK (price >= 0.0)
  , "price_currency"  TEXT     -- using discogs abbreviations
      -- if NULL, assumes USD currency.

  , "date_opened"    TEXT  -- YYYY/MM/DD
      DEFAULT CURRENT_DATE
  , "date_closed"    TEXT  -- YYYY/MM/DD
      DEFAULT NULL
  , "last_activity"  TEXT  -- YYYY/MM/DD HH:MM:SS.SSS
      DEFAULT CURRENT_TIMESTAMP

  -- Uses the enumeration defined in OrderStatus, following Discogs guidelines:
  -- https://support.discogs.com/hc/en-us/articles/360007525494
  , "status"         INTEGER
      NOT NULL         DEFAULT 0 -- new, "Invoice Sent"
      REFERENCES       OrderStatus (statusID)      
      ON DELETE        RESTRICT
      ON UPDATE        RESTRICT
);

CREATE INDEX IF NOT EXISTS "Order__Seller"
  ON Orders (seller_userID)
  ;

CREATE INDEX IF NOT EXISTS "Order__Buyer"
  ON Orders (buyer_userID)
  ;

CREATE INDEX IF NOT EXISTS "Order__Opened"
  ON Orders (date_opened)
  WHERE (date_closed IS NULL)
  ;


CREATE TABLE IF NOT EXISTS "OrderPurchases" (
    "purchaseID"   INTEGER
      PRIMARY KEY
  , "orderID"      INTEGER
      REFERENCES     Orders (orderID)
      ON DELETE      CASCADE

  , "sellerID"     INTEGER
      NOT NULL       CHECK (userID <> 0)
      REFERENCES     UserProfiles (userID)
      ON DELETE      RESTRICT
      ON UPDATE      RESTRICT
  , "versionID"    INTEGER
      NOT NULL       CHECK (versionID <> 0)
      REFERENCES     ReleaseVersions (userID)
      ON DELETE      RESTRICT
      ON UPDATE      RESTRICT
  , "item"         INTEGER
      NOT NULL       DEFAULT 1

  -- This is the price on the listing and may be adjusted before closing the
  -- order.  It must be positive; otherwise buyer and seller are swapped.
  -- If zero, the final price may also be adjusted with the Orders(offer_price)
  -- without needing to assign the difference to a specific purchase item.
  , "purchase_price"  REAL
      NOT NULL          CHECK (price >= 0.0)

  , FOREIGN KEY         ("sellerID", "versionID", "item")
    REFERENCES Listings ("userID",   "versionID", "item")
);

CREATE INDEX IF NOT EXISTS "Purchase__Order"
  ON OrderPurchases (orderID)
  ;

CREATE INDEX IF NOT EXISTS "Purchase__Seller"
  ON OrderPurchases (sellerID)
  ;

CREATE INDEX IF NOT EXISTS "Purchase__Version"
  ON OrderPurchases (versionID)
  ;


CREATE TABLE IF NOT EXISTS "OrderTrades" (
    "tradeID"      INTEGER
      PRIMARY KEY
  , "orderID"      INTEGER
      NOT NULL
      REFERENCES     Orders (orderID)
  
  , "buyerID"      INTEGER
      NOT NULL       CHECK (buyerID <> 0)
      REFERENCES     UserProfiles (userID)
      ON DELETE      RESTRICT
      ON UPDATE      RESTRICT
  , "versionID"    INTEGER
      NOT NULL       CHECK (versionID <> 0)
      REFERENCES     ReleaseVersions (userID)
      ON DELETE      RESTRICT
      ON UPDATE      RESTRICT
  , "item"         INTEGER
      NOT NULL       DEFAULT 1

  -- This is the effective trade value for the Listing;
  -- if a listing did not exist then it will be created for the order/trade.
  -- The value may be zero, with an override on the related Orders(offer_price).
  , "trade_value"  REAL
      NOT NULL       CHECK (price >= 0.0)

  , FOREIGN KEY         ("buyerID", "versionID", "item")
    REFERENCES Listings ("userID",  "versionID", "item")
);

CREATE INDEX IF NOT EXISTS "Trade__Order"
  ON OrderTrades (orderID)
  ;

CREATE INDEX IF NOT EXISTS "Trade__Buyer"
  ON OrderTrades (buyerID)
  ;

CREATE INDEX IF NOT EXISTS "Trade__Version"
  ON OrderTrades (versionID)
  ;


CREATE TABLE IF NOT EXISTS "OrderUpdates" (
    "updateID"     INTEGER
      PRIMARY KEY
  , "orderID"      INTEGER
      NOT NULL       CHECK (orderID <> 0)
      REFERENCES     Orders (orderID)
  , "update_time"  TEXT  -- YYYY/MM/DD HH:MM:SS
      DEFAULT CURRENT_TIMESTAMP

  , "comment"      TEXT
      NOT NULL       DEFAULT ""
);

CREATE INDEX IF NOT EXISTS "Update__Order"
  ON OrderUpdates (orderID)
  ;

CREATE INDEX IF NOT EXISTS "Update__Timestamp"
  ON OrderUpdates (update_time)
  ;
