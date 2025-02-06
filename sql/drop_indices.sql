-- SQL statements for dropping all indices in the cratedig database.
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
-- github:kevindamm/cratedig/sql/drop_indices.sql

-- DROP (if exists) all INDEX definitions.
-- Drop these before dropping the tables.

-- ledger
DROP INDEX IF EXISTS "Listing__User";
DROP INDEX IF EXISTS "Listing__Version";
DROP INDEX IF EXISTS "Listing__Opened";
DROP INDEX IF EXISTS "Order__Seller";
DROP INDEX IF EXISTS "Order__Buyer";
DROP INDEX IF EXISTS "Order__Opened";
DROP INDEX IF EXISTS "Purchase__Order";
DROP INDEX IF EXISTS "Purchase__Seller";
DROP INDEX IF EXISTS "Purchase__Version";
DROP INDEX IF EXISTS "Trade__Order";
DROP INDEX IF EXISTS "Trade__Buyer";
DROP INDEX IF EXISTS "Trade__Version";
DROP INDEX IF EXISTS "Update__Order";
DROP INDEX IF EXISTS "Update__Timestamp";

-- collection
DROP INDEX IF EXISTS "VinylOwned__Version";
DROP INDEX IF EXISTS "VinylOwned__Release";
DROP INDEX IF EXISTS "VinylOwned__User";
DROP INDEX IF EXISTS "UserCrates__Public";
DROP INDEX IF EXISTS "UserCrates__All";
DROP INDEX IF EXISTS "User__Active";

-- artists and groups
DROP INDEX IF EXISTS "GroupMember__Group";
DROP INDEX IF EXISTS "GroupMember__Member";
DROP INDEX IF EXISTS "URL__Artist";
DROP INDEX IF EXISTS "Name__Artist";
DROP INDEX IF EXISTS "Alias__Artist";
DROP INDEX IF EXISTS "Avatar__Artist";
DROP INDEX IF EXISTS "Avatar__Image";

-- record labels
DROP INDEX IF EXISTS "URL__Label";
DROP INDEX IF EXISTS "Label__Parent";

-- releases
DROP INDEX IF EXISTS "Artist__Release";
DROP INDEX IF EXISTS "Release__Artist";
DROP INDEX IF EXISTS "Video__Release";
DROP INDEX IF EXISTS "Genre__Release";
DROP INDEX IF EXISTS "Release__Genre";
DROP INDEX IF EXISTS "Style__Release";
DROP INDEX IF EXISTS "Release__Style";

-- release versions
DROP INDEX IF EXISTS "ReleaseVersion__Release";
DROP INDEX IF EXISTS "Artist__ReleaseVersion";
DROP INDEX IF EXISTS "ReleaseVersion__Artist";
DROP INDEX IF EXISTS "Label__ReleaseVersion";
DROP INDEX IF EXISTS "ReleaseVersion__Label";
DROP INDEX IF EXISTS "Genre__ReleaseVersion";
DROP INDEX IF EXISTS "Format__ReleaseVersion";

-- cover art
DROP INDEX IF EXISTS "CoverArt__Version";
DROP INDEX IF EXISTS "CoverArt__FrontSleeve";
DROP INDEX IF EXISTS "CoverArt__BackSleeve";
DROP INDEX IF EXISTS "CoverArt__MediaA";
DROP INDEX IF EXISTS "CoverArt__MediaB";

-- tracks
DROP INDEX IF EXISTS "Track__Unique";
DROP INDEX IF EXISTS "Track__Tracklist";
DROP INDEX IF EXISTS "Artist__Track";
DROP INDEX IF EXISTS "Track__Artist";
DROP INDEX IF EXISTS "Style__Track";
DROP INDEX IF EXISTS "Track__Style";
