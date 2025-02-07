-- Select a specific release group and some metadata about its related versions.

SELECT releaseID
  , 
  FROM Releases
  WHERE releaseID = ?
  ;