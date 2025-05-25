/*
  Warnings:

  - You are about to drop the `CetusEvent` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SnsNameRegistered` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "CetusEvent";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "SnsNameRegistered";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "CetusSwapEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "amountIn" BIGINT NOT NULL,
    "amountOut" BIGINT NOT NULL,
    "a2b" BOOLEAN NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CetusAddLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" INTEGER NOT NULL,
    "tickUpper" INTEGER NOT NULL,
    "liquidity" BIGINT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CetusRemoveLiquidityEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "tickLower" INTEGER NOT NULL,
    "tickUpper" INTEGER NOT NULL,
    "liquidity" BIGINT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CetusCollectFeeEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CetusFlashLoanEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "loanA" BOOLEAN NOT NULL,
    "partner" TEXT NOT NULL,
    "amount" BIGINT NOT NULL,
    "feeAmount" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "CetusSwapEvent_txDigest_eventSeq_key" ON "CetusSwapEvent"("txDigest", "eventSeq");

-- CreateIndex
CREATE UNIQUE INDEX "CetusAddLiquidityEvent_txDigest_eventSeq_key" ON "CetusAddLiquidityEvent"("txDigest", "eventSeq");

-- CreateIndex
CREATE UNIQUE INDEX "CetusRemoveLiquidityEvent_txDigest_eventSeq_key" ON "CetusRemoveLiquidityEvent"("txDigest", "eventSeq");

-- CreateIndex
CREATE UNIQUE INDEX "CetusCollectFeeEvent_txDigest_eventSeq_key" ON "CetusCollectFeeEvent"("txDigest", "eventSeq");

-- CreateIndex
CREATE UNIQUE INDEX "CetusFlashLoanEvent_txDigest_eventSeq_key" ON "CetusFlashLoanEvent"("txDigest", "eventSeq");
