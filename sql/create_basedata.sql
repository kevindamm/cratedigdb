-- SQL statements for populating all initial values in cratedigdb tables.
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
-- github:kevindamm/cratedigdb/sql/create_basedata.sql

-- BASE DATA
-- Contains INSERT statements for initial records and relations.

-- ASSUMES TABLES HAVE BEEN CREATED; run other create_*.sql scrpts before these.

-- The unknown user.
INSERT INTO UserProfiles
    ("userID", "username", "fullname", "date_banned")
  VALUES
    (0,        "--?",      "UNKNOWN",  "2025-01-23");

-- These values based, in part, on the Goldmine Grading Guide at discogs:
-- https://www.discogs.com/selling/resources/how-to-grade-items/
-- except quality, my own approximation based on aggregate calculations, and
-- these quality values may be subject to change, as the algorithm is tuned.
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

-- The folder with ID=0 is the catch-all which everyone implicitly has,
-- but the vinyl table constraint keeps any item from being explicitly in it.
-- Having it reified here can make client state & some queries a little simpler.
INSERT INTO Crates
    ("crateID", "userID", "name", "slug", "visible")
  VALUES
    (0,          0,       "ALL",  "all",  TRUE);

