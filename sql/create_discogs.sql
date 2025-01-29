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
-- github:kevindamm/cratedigdb/sql/create_orders.sql

-- 
-- Database TABLE and INDEX definitions for reflecting the CC0 data of Discogs.
--
-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.
--

CREATE TABLE IF NOT EXISTS "DataQuality" (
    "dqID"     INTEGER PRIMARY KEY
  , "quality"  TEXT NOT NULL
  , "summary"  TEXT NOT NULL
);

--
-- ARTISTS AND GROUPS
--
--   [---------]   N..N   [--------------------]    +index[GroupMember__Group]
--   | Artists |==========| Artist_GroupMember |---|
--   [---------]          [--------------------]    +index[GroupMember__Member]
--       |                                 +name
--       |
--       |-------[Artist_URLs] +index[Artist__URL]
--       |
--       |----[Artist_Avatars]
--       |
--       |------[Artist_Names] +index[Name__Artist]
--       |
--       \------[Artist_Alias] +index[Alias__Artist]
--

CREATE TABLE IF NOT EXISTS "Artists" (
    "artistID"  INTEGER PRIMARY KEY
  , "name"      TEXT
      NOT NULL

  , "realname"  TEXT
      DEFAULT name
  , "profile"   TEXT

  , data_quality INTEGER
      REFERENCES DataQuality (dqID)
);


CREATE TABLE IF NOT EXISTS "Artist_GroupMembers"(

);

CREATE INDEX IF NOT EXISTS "GroupMember__Group"
  ON Artist_GroupMembers (group_artistID);
CREATE INDEX IF NOT EXISTS "GroupMember__Member"
  ON Artist_GroupMembers (member_artistID);


CREATE TABLE IF NOT EXISTS "Artist_URLs" (

);

CREATE INDEX IF NOT EXISTS "URL__Artist"
  ON Artist_URLs (artistID);

CREATE TABLE IF NOT EXISTS "Artist_Avatars"(

);

CREATE TABLE IF NOT EXISTS "Artist_Names"(

);

CREATE INDEX IF NOT EXISTS "Name__Artist"
  ON Artist_Names (artistID);

CREATE TABLE IF NOT EXISTS "Artist_Alias"(

);

CREATE INDEX IF NOT EXISTS "Alias__Artist"
  ON Artist_Alias (artistID);

--
-- RECORD LABELS
--
-- ...

CREATE TABLE IF NOT EXISTS "Label_URLs" (
);

CREATE INDEX IF NOT EXISTS "Label__URL"
  ON Label_URLs (labelID);

CREATE TABLE IF NOT EXISTS "Label_Avatars" (
);

CREATE TABLE IF NOT EXISTS "Labels" (
);

CREATE INDEX IF NOT EXISTS "Label__Parent"
  ON Labels (parentID);

--
-- RELEASES
--
-- ...

CREATE TABLE IF NOT EXISTS "Releases" (
 -- TODO
);

CREATE TABLE IF NOT EXISTS "Release_Artists" (
 -- TODO
);

CREATE INDEX IF NOT EXISTS "Release_Artist__Release"
  ON Release_Artists (releaseID);
CREATE INDEX IF NOT EXISTS "Release_Artist__Artist"
  ON Release_Artists (artistID);

CREATE TABLE IF NOT EXISTS "Release_Videos" (
 -- TODO
);

CREATE INDEX IF NOT EXISTS "Release_Video__Release"
  ON Release_Videos (releaseID);

CREATE TABLE IF NOT EXISTS "Release_Genres" (
 -- TODO
);

CREATE INDEX IF NOT EXISTS "Release_Genre__Release"
  ON Release_Genres (releaseID);

CREATE TABLE IF NOT EXISTS "Release_Styles" (
 -- TODO
);

CREATE INDEX IF NOT EXISTS "Release_Styles__Release"
  ON Release_Styles (releaseID);

CREATE TABLE IF NOT EXISTS "Release_CoverArt" (
 -- TODO
);

CREATE INDEX IF NOT EXISTS "CoverArt__Release"
  ON Release_CoverArt (releaseID);

--
-- RELEASE VERSIONS
--
-- ...

CREATE TABLE IF NOT EXISTS "ReleaseVersions" (
  --TODO
);

CREATE INDEX "ReleaseVersion__Release"
  ON ReleaseVersions (releaseID);

CREATE TABLE IF NOT EXISTS "ReleaseVersion_Artists" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "ReleaseVersion_Artist__ReleaseVersion"
  ON ReleaseVersion_Artists (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion_Artist__Artist"
  ON ReleaseVersion_Artists (artistID);

CREATE TABLE IF NOT EXISTS "ReleaseVersion_Labels" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "ReleaseVersion_Label__ReleaseVersion"
  ON ReleaseVersion_Labels (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion_Label__Label"
  ON ReleaseVersion_Labels (labelID);

CREATE TABLE IF NOT EXISTS "ReleaseVersion_Genres" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "ReleaseVersion_Genre__ReleaseVersion"
  ON ReleaseVersion_Genres (release_id);

CREATE TABLE IF NOT EXISTS "ReleaseVersion_Styles" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Formats" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Tracks" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_TrackArtists" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Identifiers" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Videos" (
  --TODO
);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Companies" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "ReleaseVersion_Company__ReleaseVersion"
  ON ReleaseVersion_Companies (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion_Company__Company"
  ON ReleaseVersion_Companies (companyID);

CREATE TABLE IF NOT EXISTS "ReleaseVersion_CoverArt" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "CoverArt__ReleaseVersion"
  ON ReleaseVersion_CoverArt (versionID);

--
-- COVER ART
--
-- This table connects a release and/or its release versions to the front and
-- back images used for visually representing a RecordVersion.

CREATE TABLE IF NOT EXISTS "CoverArt" (

);

CREATE INDEX IF NOT EXISTS "CoverArt__ID"
  ON CoverArt (imageID);
