-- Select a specific version and related artist, label and release metadata.

SELECT * FROM ReleaseVersions
  WHERE versionID = ?
  ORDER BY
      data_quality DESC
    , year_released DESC
  ;
