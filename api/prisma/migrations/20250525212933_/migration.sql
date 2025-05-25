-- CreateTable
CREATE TABLE "ScallopMint" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sender" TEXT,
    "depositAsset" TEXT,
    "depositAmount" TEXT,
    "mintAsset" TEXT,
    "mintAmount" TEXT,
    "minter" TEXT,
    "mintTime" TEXT,
    "timestampMs" TEXT
);
