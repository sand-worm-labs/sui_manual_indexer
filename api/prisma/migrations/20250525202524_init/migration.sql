-- CreateTable
CREATE TABLE "Cursor" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "eventSeq" TEXT NOT NULL,
    "txDigest" TEXT NOT NULL
);

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
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
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
    "tickLower" BIGINT NOT NULL,
    "tickUpper" BIGINT NOT NULL,
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

-- CreateTable
CREATE TABLE "ScallopBorrowDynamic" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "coinType" TEXT NOT NULL,
    "borrowIndex" TEXT NOT NULL DEFAULT '',
    "interestRate" TEXT NOT NULL DEFAULT '',
    "interestRateScale" TEXT NOT NULL DEFAULT '',
    "lastUpdated" TEXT NOT NULL DEFAULT ''
);

-- CreateTable
CREATE TABLE "ScallopDeposit" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "asset" TEXT,
    "amount" TEXT,
    "timestampMs" TEXT,
    "obligation_id" TEXT NOT NULL,
    CONSTRAINT "ScallopDeposit_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation" ("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ScallopTransfer" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "type" TEXT NOT NULL,
    "borrower" TEXT NOT NULL,
    "asset" TEXT NOT NULL,
    "amount" TEXT NOT NULL,
    "timestampMs" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "ScallopWithdraw" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "asset" TEXT,
    "amount" TEXT,
    "timestampMs" TEXT,
    "obligation_id" TEXT NOT NULL,
    CONSTRAINT "ScallopWithdraw_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation" ("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ScallopCollateral" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "asset" TEXT,
    "amount" TEXT,
    "obligation_id" TEXT NOT NULL,
    CONSTRAINT "ScallopCollateral_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation" ("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ScallopDebt" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "asset" TEXT,
    "amount" TEXT,
    "borrowIndex" TEXT NOT NULL,
    "obligation_id" TEXT NOT NULL,
    CONSTRAINT "ScallopDebt_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation" ("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ScallopObligation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "obligation_id" TEXT NOT NULL,
    "obligation_key" TEXT,
    "sender" TEXT,
    "version" TEXT,
    "timestampMs" TEXT,
    "collaterals_parent_id" TEXT,
    "debts_parent_id" TEXT,
    "collaterals_count" INTEGER NOT NULL DEFAULT 0,
    "debts_count" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
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

-- CreateIndex
CREATE UNIQUE INDEX "ScallopBorrowDynamic_coinType_key" ON "ScallopBorrowDynamic"("coinType");

-- CreateIndex
CREATE UNIQUE INDEX "ScallopObligation_obligation_id_key" ON "ScallopObligation"("obligation_id");
