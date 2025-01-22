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

-- Each user has some number of collections, including 'all' and the default
-- collection (equivalent to uncategorized).  Additional collections may be
-- added by the user
CREATE TABLE IF NOT EXISTS "collections" (
  "name" TEXT NOT NULL
  , "slug" VARCHAR(127) NOT NULL
  , "user" INTEGER NOT NULL
  , "private" BOOLEAN NOT NULL DEFAULT (0)
);

CREATE TABLE IF NOT EXISTS "collection_items" (
  "collection_id" INTEGER NOT NULL
  , "release_id" INTEGER NOT NULL

  , FOREIGN KEY (collection_id)
    REFERENCES collections (id)
    ON DELETE CASCADE ON UPDATE NO ACTION
);
