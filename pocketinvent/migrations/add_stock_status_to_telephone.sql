-- Migration: Add stock_status column to telephone table
-- Date: 2026-01-14
-- Purpose: Support financial dashboard and transaction workflow with return management

-- Step 1: Add the stock_status column with default value
ALTER TABLE telephone 
ADD COLUMN stock_status TEXT NOT NULL DEFAULT 'enStock'
CHECK (stock_status IN ('enStock', 'vendu', 'retourne'));

-- Step 2: Update existing data with default status
-- All existing phones should be marked as 'enStock' by default
UPDATE telephone 
SET stock_status = 'enStock' 
WHERE stock_status IS NULL;

-- Step 3: Create indexes for optimized queries
-- Index for filtering by stock status
CREATE INDEX idx_telephone_stock_status ON telephone(stock_status);

-- Composite index for user-specific stock status queries (most common use case)
CREATE INDEX idx_telephone_user_status ON telephone(user_id, stock_status);

-- Composite index for date-based queries with status
CREATE INDEX idx_telephone_date_status ON telephone(date_entree, stock_status);

-- Step 4: Add comment to document the column
COMMENT ON COLUMN telephone.stock_status IS 'Current stock status of the phone: enStock (available for sale), vendu (sold, requires return before resale), retourne (returned, can be resold)';

-- Verification query (optional - for manual testing)
-- SELECT stock_status, COUNT(*) as count FROM telephone GROUP BY stock_status;
