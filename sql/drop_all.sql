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

-- Indices (drop collection)
DROP INDEX IF EXISTS "Vinyl";
DROP INDEX IF EXISTS "VinylVersions";
DROP INDEX IF EXISTS "PublicCrates";
DROP INDEX IF EXISTS "UserCrates";
DROP INDEX IF EXISTS "Usernames";

-- Tables (drop collection)
DROP TABLE IF EXISTS "VinylTagging";
DROP TABLE IF EXISTS "TagNames";
DROP TABLE IF EXISTS "VinylItems";
DROP TABLE IF EXISTS "Crates";
DROP TABLE IF EXISTS "Grading";
DROP TABLE IF EXISTS "UserProfiles";

-- Indices (drop orders)
-- TODO

-- Tables (drop orders)
-- TODO

-- Indices (drop discogs)
DROP INDEX IF EXISTS "URL__Artist";
DROP INDEX IF EXISTS "Name__Artist";
DROP INDEX IF EXISTS "Alias__Artist";
DROP INDEX IF EXISTS "GroupMember__Group";
DROP INDEX IF EXISTS "GroupMember__Member";
DROP INDEX IF EXISTS "Label__URL";
DROP INDEX IF EXISTS "Label__Parent";

DROP INDEX IF EXISTS "Release_Artist__Release";
DROP INDEX IF EXISTS "Release_Artist__Artist";
DROP INDEX IF EXISTS "Release_Video__Release";
DROP INDEX IF EXISTS "Release_Genre__Release";
DROP INDEX IF EXISTS "Release_Style__Release";

DROP INDEX IF EXISTS "ReleaseVersion_Artist__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Artist__Artist";
DROP INDEX IF EXISTS "ReleaseVersion_Label__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Label__Label";
DROP INDEX IF EXISTS "ReleaseVersion_Genre__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Style__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Format__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Track__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Track__Sequence";
DROP INDEX IF EXISTS "ReleaseVersion_Track__Parent";
DROP INDEX IF EXISTS "ReleaseVersion_TrackArtist__Release";
DROP INDEX IF EXISTS "ReleaseVersion_TrackArtist__TrackSequence";
DROP INDEX IF EXISTS "ReleaseVersion_TrackArtist__Artist";

DROP INDEX IF EXISTS "ReleaseVersion_Identifier__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Video__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Company__Release";
DROP INDEX IF EXISTS "ReleaseVersion_Company__Company";

-- Tables (drop discogs)
DROP TABLE IF EXISTS "Artist_URLs";
DROP TABLE IF EXISTS "Artist_Avatars";
DROP TABLE IF EXISTS "Artist_Names";
DROP TABLE IF EXISTS "Artist_Alias";
DROP TABLE IF EXISTS "Artist_GroupMembers";
DROP TABLE IF EXISTS "Artists";

DROP TABLE IF EXISTS "Label_URLs";
DROP TABLE IF EXISTS "Label_Avatars";
DROP TABLE IF EXISTS "Labels";

DROP TABLE IF EXISTS "Release_Artists";
DROP TABLE IF EXISTS "Release_Videos";
DROP TABLE IF EXISTS "Release_Genres";
DROP TABLE IF EXISTS "Release_Styles";
DROP TABLE IF EXISTS "Release_CoverArt";
DROP TABLE IF EXISTS "Releases";

DROP TABLE IF EXISTS "ReleaseVersion_Artists";
DROP TABLE IF EXISTS "ReleaseVersion_Labels";
DROP TABLE IF EXISTS "ReleaseVersion_Genres";
DROP TABLE IF EXISTS "ReleaseVersion_Styles";
DROP TABLE IF EXISTS "ReleaseVersion_Formats";
DROP TABLE IF EXISTS "ReleaseVersion_Tracks";
DROP TABLE IF EXISTS "ReleaseVersion_TrackArtists";
DROP TABLE IF EXISTS "ReleaseVersion_Identifiers";
DROP TABLE IF EXISTS "ReleaseVersion_Videos";
DROP TABLE IF EXISTS "ReleaseVersion_Companies";
DROP TABLE IF EXISTS "ReleaseVersion_CoverArt";
DROP TABLE IF EXISTS "ReleaseVersions";

DROP TABLE IF EXISTS "CoverArt";
