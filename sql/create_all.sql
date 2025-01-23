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

-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.

--
-- USER PROFILES AND USERNAME INDEX
--

CREATE TABLE IF NOT EXISTS "user_profiles" (
  "userID"       INTEGER PRIMARY KEY

  , "username"   TEXT
      UNIQUE    ON CONFLICT ROLLBACK
      NOT NULL  ON CONFLICT IGNORE
  , "fullname"   TEXT
  , "discogsID"  TEXT
  , "avatarURL"  TEXT
  , "about"      TEXT
);

-- Lookup of user ID by their username.
CREATE UNIQUE INDEX IF NOT EXISTS "usernames"
  ON user_profiles (userID, username);

--
-- COLLECTIONS AND TAGGING
--

-- Each user has some number of folders, including 'all' and the default
-- folder (where unsorted vinyl go).  Additional folders may be added or removed
-- by the user for organizing their collection with a physical metaphor.
-- See `tags` for a virtual metaphor, where an item can belong to more than one.
CREATE TABLE IF NOT EXISTS "folders" (
    "folderID"  INTEGER PRIMARY KEY

  -- TODO allow nested folders? it's probably overkill, defer deciding for now
  --, "parentID"    INTEGER         -- a root folder if parent_id == NULL
  --    CHECK (parentID <> crateID  -- disallow direct self-inclusion
  --    AND    parentID <> 0)       -- folder ID 0 is implicitly 'all crates'
  , "name"      TEXT          NOT NULL
  , "slug"      VARCHAR(127)  NOT NULL
  , "userID"    INTEGER       NOT NULL
  , "visible"   BOOLEAN       NOT NULL DEFAULT (1) -- defaults to public

  , FOREIGN KEY (userID)
      REFERENCES user_profiles (userID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION

  --, FOREIGN KEY (parentID)
  --    REFERENCES folders (folderID)
  --    ON DELETE CASCADE
  --    ON UPDATE NO ACTION
);

-- Index of all folders for a user.
CREATE UNIQUE INDEX IF NOT EXISTS "user_folders"
  ON folders (userID, folderID);

-- Index of only publicly-visible folders for a user.
CREATE UNIQUE INDEX IF NOT EXISTS "public_folders"
  ON folders (userID, folderID)
  WHERE (visible <> 0);

-- An item may only be in one folder or in none, but not in multiple
-- folders.  If the folder for an item is removed, that removes it but
-- doesn't remove the item itself, it instead becomes unsorted.
CREATE TABLE IF NOT EXISTS "vinyl_records" (
    "vinylID"    INTEGER PRIMARY KEY

  , "folderID"   INTEGER     -- NULL implies unsorted,
      CHECK (folderID <> 0)  -- zero is the special 'ALL' folder
  , "userID"     INTEGER  NOT NULL
  , "releaseID"  INTEGER  NOT NULL
  , "quantity"   INTEGER  NOT NULL
      DEFAULT (1)
      CHECK   (quantity <> 0)

  , FOREIGN KEY (folderID)
      REFERENCES folders (folderID)
      ON DELETE SET NULL
      ON UPDATE NO ACTION
);

-- Registry of tag names associated with each user and their 
CREATE TABLE IF NOT EXISTS "tag_names" (
    "tagID"    INTEGER  PRIMARY KEY

  , "userID"   INTEGER  NOT NULL
      CHECK (userID <> 0)
  , "tagName"  TEXT     NOT NULL
      CHECK (tagID <> 0)
);

-- Many-to-many relation for annotating vinyl with tags.  The two IDs need to
-- both be associated with the same user ID in their respective tables, which
-- business logic and the INSERT clause can assist in enforcing.
CREATE TABLE IF NOT EXISTS "vinyl_tagging" (
    "vinylID"  INTEGER NOT NULL
  , "tagID"    INTEGER NOT NULL

  , FOREIGN KEY (vinylID)
      REFERENCES "vinyl_records" (vinylID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
  , FOREIGN KEY (tagID)
      REFERENCES "tag_names" (tagID)
      ON DELETE CASCADE
      ON UPDATE NO ACTION

  , UNIQUE (vinylID, tagID)
      ON CONFLICT IGNORE
);
