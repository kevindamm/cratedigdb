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

-- The unknown user.
INSERT INTO UserProfiles
    ("userID", "username", "fullname", "date_banned")
  VALUES
    (0,        "?",        "UNKNOWN",  "2025-01-23");

-- Lookup of user ID by their username.
CREATE UNIQUE INDEX IF NOT EXISTS "Usernames"
  ON UserProfiles
    ("userID", "username")
  WHERE (date_banned is NULL);

--
-- GRADING
--

-- An enum table referenced by VinylItems columns mediaGrade and sleeveGrade.
CREATE TABLE IF NOT EXISTS "Grading" (
    "gradeID" INTEGER PRIMARY KEY
  , "grade"   TEXT NOT NULL
  , "name"    TEXT NOT NULL
  , "quality" INTEGER NOT NULL
);

-- These values based, in part, on the Goldmine Grading Guide at discogs:
-- https://www.discogs.com/selling/resources/how-to-grade-items/
-- except quality, my own approximation based on aggregate calculations, and
-- these quality values may change so derived values may take that into account.
INSERT INTO Grading
         ("gradeID", "grade", "name",    "quality")
  VALUES (0,         "",      "UNKNOWN",        50)
       , (1,         "M",     "Mint",          100)
       , (2,         "NM",    "Near Mint",      90)
       , (3,         "VG+",   "Very Good Plus", 70)
       , (4,         "VG",    "Very Good",      45)
       , (5,         "G+",    "Good Plus",      35)
       , (6,         "G",     "Good",           30)
       , (7,         "F",     "Fair",           10)
       , (8,         "P",     "Poor",            5)
       ;

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
    "crateID"   INTEGER PRIMARY KEY
  , "userID"    INTEGER
      NOT NULL
      REFERENCES UserProfiles (userID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
  , "parentID"  INTEGER           -- a root crate if parent_id == NULL
      REFERENCES Crates (crateID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
      CHECK (parentID <> crateID  -- disallow direct self-inclusion
      AND    parentID <> 0)       -- crate ID 0 is implicitly 'all crates'

  , "visible"   BOOLEAN
      NOT NULL DEFAULT TRUE       -- defaults to public
  , "name"      TEXT
      NOT NULL
  , "slug"      VARCHAR(127)
      NOT NULL
      CHECK (slug <> "")
  , "notes"     TEXT
      NOT NULL DEFAULT ""

  -- No two folders in the same parent folder may have the same name.
  , UNIQUE ("userID", "parentID", "name") 
      ON CONFLICT ROLLBACK
);

-- The folder with ID=0 is the catch-all which everyone implicitly has,
-- but the vinyl table constraint keeps any item from being explicitly in it.
-- Having it reified here can make client state & some queries a little simpler.
INSERT INTO Crates
    ("crateID", "userID", "name", "slug", "visible")
  VALUES
    (0,          0,       "ALL",  "all",  TRUE);

CREATE UNIQUE INDEX IF NOT EXISTS "UserCrates"
  ON Crates
    (userID, crateID);

CREATE UNIQUE INDEX IF NOT EXISTS "PublicCrates"
  ON Crates
    (userID, crateID)
  WHERE (visible <> 0);

-- PRIMARY KEY is a composite of columns (user, release, version, instance);
-- we intend to track each individual copy's state of quality, and possession,
-- and a copy is defined by the user and the specific version of a release.
CREATE TABLE IF NOT EXISTS "VinylItems" (
    "userID"        INTEGER  NOT NULL
      REFERENCES UserProfiles (userID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION

  , "releaseID"     INTEGER  NOT NULL
  , "versionID"     INTEGER  NOT NULL
  , "instance"      INTEGER
      NOT NULL    DEFAULT 1
      CHECK       (instance > 0)

  -- Exclusive position, in only one crate at a time, or not in any crates.
  , "crateID"      INTEGER
      CHECK      (crateID <> 0)  -- zero is reserved for the special 'ALL' crate
                                 -- NULL implies unsorted, only listed with ALL.

  -- Note: all dates are in YYYY-MM-DD format.
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

  , PRIMARY KEY ("userID", "releaseID", "versionID", "instance")

  -- These keys match the discogs `release` and `master` IDs,
  -- which will be reflected in tables local to this database
  -- (in a later version).
  -- , FOREIGN KEY ("releaseID") ...
  -- , FOREIGN KEY ("versionID") ...

  , FOREIGN KEY ("crateID")
      REFERENCES Crates (crateID)
      ON DELETE SET NULL  -- keep the item in the ALL folder
      ON UPDATE NO ACTION

) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Vinyl"
  ON VinylItems
    (userID, releaseID)
  WHERE (date_sold IS NULL
    AND date_traded IS NULL)
  ;

CREATE INDEX IF NOT EXISTS "VinylVersions"
  ON VinylItems
    (userID, releaseID, versionID)
  WHERE (date_sold IS NULL
    AND date_traded IS NULL)
  ;

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
-- Many-to-many relation for annotating vinyl with tags.  The two IDs need to
-- both be associated with the same user ID in their respective tables, which
-- business logic and the INSERT clause can assist in enforcing.

CREATE TABLE IF NOT EXISTS "TagNames" (
    "tagID"    INTEGER  PRIMARY KEY
  , "userID"   INTEGER  NOT NULL
      REFERENCES Usernames (userID)
      CHECK (userID <> 0)

  , "name"  TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS "VinylTagging" (
    "userID"     INTEGER NOT NULL
  , "releaseID"  INTEGER NOT NULL

  , "tagID"      INTEGER NOT NULL
      REFERENCES TagNames (tagID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION

  , FOREIGN KEY ("userID", "releaseID")
      REFERENCES Vinyl (userID, releaseID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION

  , UNIQUE ("userID", "releaseID", "tagID")
      ON CONFLICT IGNORE
);
