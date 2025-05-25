/*
  Warnings:

  - You are about to drop the column `sender` on the `ScallopMint` table. All the data in the column will be lost.

*/
-- CreateTable
CREATE TABLE "ScallopRedeem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sender" TEXT NOT NULL,
    "withdrawAsset" TEXT,
    "withdrawAmount" TEXT,
    "burnAsset" TEXT,
    "burnAmount" TEXT,
    "redeemer" TEXT,
    "redeemTime" TEXT,
    "timestampMs" TEXT
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ScallopMint" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "depositAsset" TEXT,
    "depositAmount" TEXT,
    "mintAsset" TEXT,
    "mintAmount" TEXT,
    "minter" TEXT,
    "mintTime" TEXT,
    "timestampMs" TEXT
);
INSERT INTO "new_ScallopMint" ("depositAmount", "depositAsset", "id", "mintAmount", "mintAsset", "mintTime", "minter", "timestampMs") SELECT "depositAmount", "depositAsset", "id", "mintAmount", "mintAsset", "mintTime", "minter", "timestampMs" FROM "ScallopMint";
DROP TABLE "ScallopMint";
ALTER TABLE "new_ScallopMint" RENAME TO "ScallopMint";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
