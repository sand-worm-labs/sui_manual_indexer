-- CreateTable
CREATE TABLE "Cursor" (
    "id" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "txDigest" TEXT NOT NULL,

    CONSTRAINT "Cursor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CetusSwapEvent" (
    "id" TEXT NOT NULL,
    "pool" TEXT NOT NULL,
    "amount_in" BIGINT NOT NULL,
    "amount_out" BIGINT NOT NULL,
    "atob" BOOLEAN NOT NULL,
    "fee_amount" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL,

    CONSTRAINT "CetusSwapEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CetusAddLiquidityEvent" (
    "id" TEXT NOT NULL,
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
    "timestampMs" BIGINT NOT NULL,

    CONSTRAINT "CetusAddLiquidityEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CetusRemoveLiquidityEvent" (
    "id" TEXT NOT NULL,
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
    "timestampMs" BIGINT NOT NULL,

    CONSTRAINT "CetusRemoveLiquidityEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CetusCollectFeeEvent" (
    "id" TEXT NOT NULL,
    "pool" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "amountA" BIGINT NOT NULL,
    "amountB" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "timestampMs" BIGINT NOT NULL,

    CONSTRAINT "CetusCollectFeeEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CetusFlashLoanEvent" (
    "id" TEXT NOT NULL,
    "pool" TEXT NOT NULL,
    "loanA" BOOLEAN NOT NULL,
    "partner" TEXT NOT NULL,
    "amount" BIGINT NOT NULL,
    "feeAmount" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL,

    CONSTRAINT "CetusFlashLoanEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopBorrowDynamic" (
    "id" TEXT NOT NULL,
    "coinType" TEXT NOT NULL,
    "borrowIndex" TEXT NOT NULL DEFAULT '',
    "interestRate" TEXT NOT NULL DEFAULT '',
    "interestRateScale" TEXT NOT NULL DEFAULT '',
    "lastUpdated" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "ScallopBorrowDynamic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopDeposit" (
    "id" TEXT NOT NULL,
    "asset" TEXT,
    "amount" TEXT,
    "timestampMs" TEXT,
    "obligation_id" TEXT NOT NULL,

    CONSTRAINT "ScallopDeposit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopMint" (
    "id" TEXT NOT NULL,
    "depositAsset" TEXT,
    "depositAmount" TEXT,
    "mintAsset" TEXT,
    "mintAmount" TEXT,
    "minter" TEXT,
    "mintTime" TEXT,
    "timestampMs" TEXT,

    CONSTRAINT "ScallopMint_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopRedeem" (
    "id" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "withdrawAsset" TEXT,
    "withdrawAmount" TEXT,
    "burnAsset" TEXT,
    "burnAmount" TEXT,
    "redeemer" TEXT,
    "redeemTime" TEXT,
    "timestampMs" TEXT,

    CONSTRAINT "ScallopRedeem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopTransfer" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "borrower" TEXT NOT NULL,
    "asset" TEXT NOT NULL,
    "amount" TEXT NOT NULL,
    "timestampMs" TEXT NOT NULL,

    CONSTRAINT "ScallopTransfer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopWithdraw" (
    "id" TEXT NOT NULL,
    "asset" TEXT,
    "amount" TEXT,
    "timestampMs" TEXT,
    "taker" TEXT,
    "obligation_id" TEXT NOT NULL,

    CONSTRAINT "ScallopWithdraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopCollateral" (
    "id" TEXT NOT NULL,
    "asset" TEXT,
    "amount" TEXT,
    "obligation_id" TEXT NOT NULL,

    CONSTRAINT "ScallopCollateral_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopDebt" (
    "id" TEXT NOT NULL,
    "asset" TEXT,
    "amount" TEXT,
    "borrowIndex" TEXT NOT NULL,
    "obligation_id" TEXT NOT NULL,

    CONSTRAINT "ScallopDebt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScallopObligation" (
    "id" TEXT NOT NULL,
    "obligation_id" TEXT NOT NULL,
    "obligation_key" TEXT,
    "sender" TEXT,
    "version" TEXT,
    "timestampMs" TEXT,
    "collaterals_parent_id" TEXT,
    "debts_parent_id" TEXT,
    "collaterals_count" INTEGER NOT NULL DEFAULT 0,
    "debts_count" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ScallopObligation_pkey" PRIMARY KEY ("id")
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

-- AddForeignKey
ALTER TABLE "ScallopDeposit" ADD CONSTRAINT "ScallopDeposit_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation"("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScallopWithdraw" ADD CONSTRAINT "ScallopWithdraw_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation"("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScallopCollateral" ADD CONSTRAINT "ScallopCollateral_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation"("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScallopDebt" ADD CONSTRAINT "ScallopDebt_obligation_id_fkey" FOREIGN KEY ("obligation_id") REFERENCES "ScallopObligation"("obligation_id") ON DELETE RESTRICT ON UPDATE CASCADE;
