-- SQL statements for dropping all tables in the cratedig database.
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
-- github:kevindamm/cratedig/sql/drop_all.sql

-- Indices (drop all)
DROP INDEX IF EXISTS "Vinyl";
DROP INDEX IF EXISTS "VinylVersions";
DROP INDEX IF EXISTS "PublicCrates";
DROP INDEX IF EXISTS "UserCrates";
DROP INDEX IF EXISTS "Usernames";

-- Tables (drop all)
DROP TABLE IF EXISTS "VinylTagging";
DROP TABLE IF EXISTS "TagNames";
DROP TABLE IF EXISTS "VinylItems";
DROP TABLE IF EXISTS "Crates";
DROP TABLE IF EXISTS "Grading";
DROP TABLE IF EXISTS "UserProfiles";
