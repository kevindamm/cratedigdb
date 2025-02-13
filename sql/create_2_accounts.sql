-- SQL statements for creating accounts-related CrateDig DB tables.
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
-- github:kevindamm/cratedigdb/sql/create_2_accounts.sql

-- 
-- Database TABLE and INDEX definitions for representing accounts and linking
-- to discogs identities and interactions through CrateDig & vinyl.kevindamm.com
--
-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.
--

--
-- USER ACCOUNTS
--
--    [--------------]                       [-----------]
--    | UserAccounts |---INDEX(userID)-------| Usernames |
--    [--------------]     WHERE NOT banned  [-----------]
--         |
--         |-----------------------------[ User_Tokens ]
--         |
--         |     [--------------]
--         '-----| User_Avatars |
--               [--------------]
--
-- User profiles are identified by their unique userID, but the more readable
-- representation (username) is how they are indexed throughout the site.
--
-- This username index is constrained to include only non-banned users.

CREATE TABLE IF NOT EXISTS "UserAccounts" (
    "userID"      INTEGER PRIMARY KEY
  , "username"    TEXT
      UNIQUE    ON CONFLICT ROLLBACK
      NOT NULL
  , "fullname"    TEXT
      NOT NULL  DEFAULT username
  , "about"       TEXT
      NOT NULL  DEFAULT ""
  , "discogsID"   TEXT
  , "avatarURL"   TEXT

  , "date_banned" TEXT  -- YYYY-MM-DD
      -- A NULL date_banned value implies the user is not banned.
);

-- Lookup of (non-banned) accounts by their username.
CREATE UNIQUE INDEX IF NOT EXISTS "User__Active"
  ON UserAccounts (username)
  WHERE (date_banned is NULL)
  ;

-- The avatar image for each user.
CREATE TABLE IF NOT EXISTS "User_Avatars" (
    "userID"      INTEGER
      NOT NULL
      REFERENCES    UserAccounts (userID)
      ON DELETE     CASCADE
  , "imageID"     INTEGER
      NOT NULL
      REFERENCES    ImageData (imageID)
      ON DELETE     CASCADE
  
  , PRIMARY KEY ("userID", "imageID")
) WITHOUT ROWID;

CREATE UNIQUE INDEX IF NOT EXISTS  "Avatar__User"
  ON User_Avatars (userID)
  ;

-- Login tokens
CREATE TABLE IF NOT EXISTS "User_Tokens" (
    "userID"      INTEGER
      NOT NULL
      REFERENCES    UserAccounts (userID)
      ON DELETE     CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "Token__User"
  ON User_Tokens (userID)
  ;
