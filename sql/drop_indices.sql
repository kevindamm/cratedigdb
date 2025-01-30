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

-- TODO (drop ledger indices)

-- drop collection indices
DROP INDEX IF EXISTS "Vinyl";
DROP INDEX IF EXISTS "VinylVersions";
DROP INDEX IF EXISTS "PublicCrates";
DROP INDEX IF EXISTS "UserCrates";
DROP INDEX IF EXISTS "Usernames";

-- drop discogs indices
DROP INDEX IF EXISTS "URL__Artist";
DROP INDEX IF EXISTS "Name__Artist";
DROP INDEX IF EXISTS "Alias__Artist";
DROP INDEX IF EXISTS "GroupMembers__Unique";
DROP INDEX IF EXISTS "GroupMember__Group";
DROP INDEX IF EXISTS "GroupMember__Member";

DROP INDEX IF EXISTS "URL__Label";
DROP INDEX IF EXISTS "Label__Parent";

DROP INDEX IF EXISTS "Artist__Release";
DROP INDEX IF EXISTS "Release__Artist";
DROP INDEX IF EXISTS "Video__Release";
DROP INDEX IF EXISTS "Genre__Release";
DROP INDEX IF EXISTS "Style__Release";

DROP INDEX IF EXISTS "Artist__ReleaseVersion";
DROP INDEX IF EXISTS "ReleaseVersion__Artist";
DROP INDEX IF EXISTS "Label__ReleaseVersion";
DROP INDEX IF EXISTS "ReleaseVersion__Label";
DROP INDEX IF EXISTS "Genre__ReleaseVersion";
DROP INDEX IF EXISTS "Style__ReleaseVersion";
DROP INDEX IF EXISTS "Format__ReleaseVersion";
DROP INDEX IF EXISTS "Track__ReleaseVersion";
DROP INDEX IF EXISTS "Track__TrackSequence";
DROP INDEX IF EXISTS "TrackArtist__ReleaseVersion";
DROP INDEX IF EXISTS "TrackArtist__Track";
DROP INDEX IF EXISTS "TrackArtist__TrackSequence";
DROP INDEX IF EXISTS "TrackArtist__Artist";
DROP INDEX IF EXISTS "Identifier__ReleaseVersion";
DROP INDEX IF EXISTS "Video__ReleaseVersion";
DROP INDEX IF EXISTS "Company__ReleaseVersion";
DROP INDEX IF EXISTS "ReleaseVersion__Company";

DROP INDEX IF EXISTS "Artist_Avatar__Unique";
DROP INDEX IF EXISTS "Label_Avatar__Unique";
DROP INDEX IF EXISTS "Release_CoverArt__Unique";
DROP INDEX IF EXISTS "ReleaseVersion_CoverArt__Unique";
