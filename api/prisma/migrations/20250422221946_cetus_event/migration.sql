-- CreateTable
CREATE TABLE "CetusEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "amountIn" BIGINT NOT NULL,
    "amountOut" BIGINT NOT NULL,
    "a2b" BOOLEAN NOT NULL,
    "byAmountIn" BOOLEAN NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "CetusEvent_txDigest_eventSeq_key" ON "CetusEvent"("txDigest", "eventSeq");
