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
-- github:kevindamm/cratedig/sql/create_all.sql

-- 
-- Database TABLE and INDEX definitions for representing items in a collection.
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
--    [--------------]                         [-----------]
--    | UserProfiles |---INDEX(userID, name)---| Usernames |
--    [--------------]     WHERE NOT banned    [-----------]
--
-- User profiles are identified by their rowid but the more human-readable
-- representation (username) is how they are indexed throughout the site.  So,
-- the `usernames` index is a one-to-one mapping over `user_profiles` IDs for
-- looking up the number or name, depending on which is held.
--
-- This username index is constrained to include only non-banned users.

CREATE TABLE IF NOT EXISTS "UserProfiles" (
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

CREATE INDEX IF NOT EXISTS "User__Username"
  ON UserProfiles (username)
  ;

-- Lookup of user ID by their username.
CREATE UNIQUE INDEX IF NOT EXISTS "User__Active"
  ON UserProfiles (userID)
  WHERE (date_banned is NULL)
  ;

--
-- GRADING
--

-- An enum table referenced by VinylItems columns mediaGrade and sleeveGrade.
-- see create_4_basedats.sql for the grading definitions.
CREATE TABLE IF NOT EXISTS "Grading" (
    "gradeID" INTEGER PRIMARY KEY
  , "grade"   TEXT NOT NULL
  , "name"    TEXT NOT NULL
  , "quality" INTEGER NOT NULL
);

--
-- COLLECTIONS
--
--          [--------]
--    /-----| Crates |---N..1---[userID]
--    |     [--------]
--    |       ^  | |                                          
--    |  N..1 |  | \------UNIQUE(userID, parentID, name)----.--- (visible)
--    \-------'  |                                           \   ? PublicCrates
--   (parentID)  |          [------------]                    -- : UserCrates
--               \---1..N---| VinylItems |--2..1--[Grading]
--                          [------------]         (media,
--                                 |                sleeve)
--                                 |            
--                                 |-----INDEX(userID, releaseID, versionID)
--                                 |     = VinylVersions
--                                 |
--                                 \-----INDEX(userID, releaseID)
--                                       = Vinyl
--
-- Each user has some number of crates, including 'all' and the default
-- crate (where unsorted vinyl go).  Additional crates may be added or removed
-- by the user for organizing their collection with a physical metaphor.
-- Use `tags` for a virtual metaphor, where an item can belong to more than one.
--
-- An item may only be in one crate or in none, but not in multiple
-- crates.  If the crate for an item is removed, that removes it but
-- doesn't remove the item itself, it instead becomes unsorted.

CREATE TABLE IF NOT EXISTS "Crates" (
    "crateID"       INTEGER
      PRIMARY KEY
  , "userID"        INTEGER
      NOT NULL
      REFERENCES UserProfiles (userID)
      ON DELETE  CASCADE
  , "parentID"      INTEGER            -- if parent_id IS NULL, top-level crate
      REFERENCES Crates (crateID)
      ON DELETE  CASCADE
      CHECK      (parentID <> crateID  -- disallow direct self-inclusion
                  AND parentID > 0)    -- crate ID 0 is implicitly 'all crates'
  , "name"          TEXT
      NOT NULL

  , "visible"       BOOLEAN
      NOT NULL   DEFAULT TRUE          -- defaults to public
  , "slug"          VARCHAR(127)
      NOT NULL
      CHECK      (slug <> "")
  , "notes"         TEXT
      NOT NULL   DEFAULT ""

  -- No two folders in the same parent folder may have the same name.
  , UNIQUE ("userID", "parentID", "name") 
      ON CONFLICT ROLLBACK
);

CREATE UNIQUE INDEX IF NOT EXISTS "UserCrates_All"
  ON Crates
    (userID, crateID);

CREATE UNIQUE INDEX IF NOT EXISTS "UserCrates__Public"
  ON Crates
    (userID, crateID)
  WHERE (visible <> 0);

-- Represents a single copy of a release version and its related metadata.  We
-- track each copy individually for their own grading and purchase/sale history.
CREATE TABLE IF NOT EXISTS "VinylItems" (
  -- PRIMARY KEY is a composite of columns (user, release, version, item)
    "userID"        INTEGER
      NOT NULL
      REFERENCES  UserProfiles (userID)
      ON DELETE   CASCADE
  , "releaseID"     INTEGER
      NOT NULL
      REFERENCES  Releases (releaseID)
      ON DELETE   CASCADE
  , "versionID"     INTEGER
      NOT NULL
      REFERENCES  ReleaseVersions (versionID)
      ON DELETE   CASCADE
  , "item"      INTEGER
      NOT NULL    DEFAULT 1
      CHECK       (item > 0)

  -- Exclusively exists in only one crate at a time, or (NULL) not in any crate.
  , "crateID"       INTEGER
      CHECK       (crateID > 0)  -- zero is reserved for the special 'ALL' crate
      DEFAULT     NULL           -- NULL implies unsorted, only listed with ALL.
      REFERENCES  Crates (crateID)
      ON DELETE   SET NULL  -- keep the vinyl (in ALL) if its folder is deleted

  -- Note: all dates are in YYYY-MM-DD format.  TEXT datatype because of SQLite.
  , "date_added"    TEXT
      NOT NULL    DEFAULT CURRENT_DATE
  , "date_graded"   TEXT  -- if NULL, this item has not been graded
  , "date_sold"     TEXT  -- if NULL, this item has not been sold
  , "date_traded"   TEXT  -- if NULL, this item has not been traded

  , "media_grade"   INTEGER
      NOT NULL
      REFERENCES Grading (gradeID)
  , "sleeve_grade"  INTEGER
      NOT NULL
      REFERENCES Grading (gradeID)
  , "notes"         TEXT
      NOT NULL    DEFAULT ""

  , PRIMARY KEY ("userID", "versionID", "item")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "VinylOwned__User"
  ON VinylItems (userID)
  WHERE (
          date_sold IS NULL
    AND date_traded IS NULL
  );

CREATE INDEX IF NOT EXISTS "VinylOwned__Release"
  ON VinylItems (userID, releaseID)
  WHERE (
          date_sold IS NULL
    AND date_traded IS NULL
  );

CREATE INDEX IF NOT EXISTS "VinylOwned__Version"
  ON VinylItems (userID, versionID)
  WHERE (
          date_sold IS NULL
    AND date_traded IS NULL
  );

--
-- TAGGING
--
--    [----------]
--    | TagNames |---N..1---[Usernames.userID]
--    [----------]
--          |
--          |          [--------------]
--          \---N..1---| VinylTagging |---1..1---[(userID, releaseID)]
--                     [--------------]
--
-- Registry of tag names associated with each user and their records.
--
-- Many-to-many relation for annotating vinyl with tags, with visibility
-- restricted to the user's own.

CREATE TABLE IF NOT EXISTS "TagNames" (
    "tagID"    INTEGER
      PRIMARY KEY
  , "userID"   INTEGER
      NOT NULL
      REFERENCES Usernames (userID)
      CHECK (userID <> 0)

  , "name"  TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS "VinylTagging" (
    "userID"     INTEGER
      NOT NULL
      REFERENCES   UserProfiles (userID)
  , "versionID"  INTEGER
      NOT NULL
      REFERENCES   ReleaseVersions (versionID)
  , "tagID"      INTEGER
      NOT NULL
      REFERENCES   TagNames (tagID)
      ON DELETE    CASCADE

  , PRIMARY KEY ("userID", "releaseID", "tagID")
) WITHOUT ROWID;
