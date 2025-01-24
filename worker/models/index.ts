import { z } from "zod"

export { Grading, VinylRecord } from "./vinyl"
export { VinylCrate, VinylCrateContents } from "./crates"

/** Other utility types are also included here.
 */
export const DataQuality = z.enum([
  "New Submission",
  "Recently Edited",
  "Correct",
  "Needs Vote",
  "Needs Major Changes",
  "Needs Minor Changes",
  "Entirely Incorrect",
])
