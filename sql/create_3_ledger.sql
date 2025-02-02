-- SQL statements for creating all tables in the cratedig database
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
-- github:kevindamm/cratedigdb/sql/create_3_ledger.sql

-- 
-- Database TABLE and INDEX definitions for representing sale amounts and dates
-- (intended as a convenience for operational organization and tax accounting).
--
--   [----------]   N..1
--   | Listings |--------index[Inventory__User]
--   [----------]
--       |
--       |                   *orderID
--       | N..N     [--------]        (enum)
--       '----------| Orders |--------[OrderState] 1..N
--                  [--------]                   *-----*[OrderHistory]
--                   +buyer, seller FK(userID)           |
--                                                       +index[History__Order]
--
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
    "listingID"  INTEGER
      PRIMARY KEY

  , "userID"        INTEGER
      NOT NULL        CHECK (userID <> 0)
      REFERENCES      UserProfiles (userID)
      ON DELETE       RESTRICT
      ON UPDATE       RESTRICT
  , "versionID"     INTEGER
      NOT NULL        CHECK (versionID <> 0)
      REFERENCES      ReleaseVersions (userID)
      ON DELETE       RESTRICT
      ON UPDATE       RESTRICT
  , "item"          INTEGER
      NOT NULL        DEFAULT 1

  , "price_low"     INTEGER
  , "price_high"    INTEGER
  , "price_curr"    TEXT  -- currency abbreviation

  , "allow_offers"  BOOLEAN
      NOT NULL        DEFAULT FALSE
  , "date_posted"   TEXT  -- YYYY/MM/DD
      NOT NULL        DEFAULT CURRENT_DATE
  , "date_closed"   TEXT  -- YYYY/MM/DD

  , FOREIGN KEY           ("userID", "versionID", "item")
    REFERENCES VinylItems ("userID", "versionID", "item")
);

CREATE INDEX IF NOT EXISTS "Inventory__User"
  ON Listings (userID);

-- TODO ListingComments

-- TODO Orders
-- TODO OrderItems
