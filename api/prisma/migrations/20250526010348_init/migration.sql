/*
  Warnings:

  - Added the required column `sender` to the `CetusAddLiquidityEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `timestampMs` to the `CetusAddLiquidityEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sender` to the `CetusCollectFeeEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `timestampMs` to the `CetusCollectFeeEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sender` to the `CetusRemoveLiquidityEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `timestampMs` to the `CetusRemoveLiquidityEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sender` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `timestampMs` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CetusAddLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
    "liquidity" BIGINT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusAddLiquidityEvent" ("amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "tickLower", "tickUpper", "txDigest") SELECT "amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "tickLower", "tickUpper", "txDigest" FROM "CetusAddLiquidityEvent";
DROP TABLE "CetusAddLiquidityEvent";
ALTER TABLE "new_CetusAddLiquidityEvent" RENAME TO "CetusAddLiquidityEvent";
CREATE UNIQUE INDEX "CetusAddLiquidityEvent_txDigest_eventSeq_key" ON "CetusAddLiquidityEvent"("txDigest", "eventSeq");
CREATE TABLE "new_CetusCollectFeeEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusCollectFeeEvent" ("amountA", "amountB", "eventSeq", "id", "pool", "position", "txDigest") SELECT "amountA", "amountB", "eventSeq", "id", "pool", "position", "txDigest" FROM "CetusCollectFeeEvent";
DROP TABLE "CetusCollectFeeEvent";
ALTER TABLE "new_CetusCollectFeeEvent" RENAME TO "CetusCollectFeeEvent";
CREATE UNIQUE INDEX "CetusCollectFeeEvent_txDigest_eventSeq_key" ON "CetusCollectFeeEvent"("txDigest", "eventSeq");
CREATE TABLE "new_CetusRemoveLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
    "liquidity" BIGINT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusRemoveLiquidityEvent" ("amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "tickLower", "tickUpper", "txDigest") SELECT "amountA", "amountB", "eventSeq", "id", "liquidity", "pool", "position", "tickLower", "tickUpper", "txDigest" FROM "CetusRemoveLiquidityEvent";
DROP TABLE "CetusRemoveLiquidityEvent";
ALTER TABLE "new_CetusRemoveLiquidityEvent" RENAME TO "CetusRemoveLiquidityEvent";
CREATE UNIQUE INDEX "CetusRemoveLiquidityEvent_txDigest_eventSeq_key" ON "CetusRemoveLiquidityEvent"("txDigest", "eventSeq");
CREATE TABLE "new_CetusSwapEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "amount_in" BIGINT NOT NULL,
    "amount_out" BIGINT NOT NULL,
    "atob" BOOLEAN NOT NULL,
    "fee_amount" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL
);
INSERT INTO "new_CetusSwapEvent" ("amount_in", "amount_out", "atob", "eventSeq", "fee_amount", "id", "pool", "txDigest") SELECT "amount_in", "amount_out", "atob", "eventSeq", "fee_amount", "id", "pool", "txDigest" FROM "CetusSwapEvent";
DROP TABLE "CetusSwapEvent";
ALTER TABLE "new_CetusSwapEvent" RENAME TO "CetusSwapEvent";
CREATE UNIQUE INDEX "CetusSwapEvent_txDigest_eventSeq_key" ON "CetusSwapEvent"("txDigest", "eventSeq");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
