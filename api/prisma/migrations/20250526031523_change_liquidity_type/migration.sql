-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CetusAddLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
    "liquidity" TEXT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusAddLiquidityEvent" ("amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "sender", "tickLower", "tickUpper", "timestampMs", "txDigest") SELECT "amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "sender", "tickLower", "tickUpper", "timestampMs", "txDigest" FROM "CetusAddLiquidityEvent";
DROP TABLE "CetusAddLiquidityEvent";
ALTER TABLE "new_CetusAddLiquidityEvent" RENAME TO "CetusAddLiquidityEvent";
CREATE UNIQUE INDEX "CetusAddLiquidityEvent_txDigest_eventSeq_key" ON "CetusAddLiquidityEvent"("txDigest", "eventSeq");
CREATE TABLE "new_CetusRemoveLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
    "liquidity" TEXT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusRemoveLiquidityEvent" ("amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "sender", "tickLower", "tickUpper", "timestampMs", "txDigest") SELECT "amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "sender", "tickLower", "tickUpper", "timestampMs", "txDigest" FROM "CetusRemoveLiquidityEvent";
DROP TABLE "CetusRemoveLiquidityEvent";
ALTER TABLE "new_CetusRemoveLiquidityEvent" RENAME TO "CetusRemoveLiquidityEvent";
CREATE UNIQUE INDEX "CetusRemoveLiquidityEvent_txDigest_eventSeq_key" ON "CetusRemoveLiquidityEvent"("txDigest", "eventSeq");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
