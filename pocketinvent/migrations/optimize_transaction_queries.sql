-- Migration: Optimize transaction queries with additional indexes
-- Date: 2026-01-15
-- Purpose: Improve performance for dashboard and transaction list queries

-- Index for filtering transactions by type
CREATE INDEX IF NOT EXISTS idx_transaction_type ON historique_transaction(type_transaction);

-- Composite index for user-specific transaction queries (most common use case)
CREATE INDEX IF NOT EXISTS idx_transaction_user_date ON historique_transaction(user_id, date_transaction DESC);

-- Composite index for user and type filtering
CREATE INDEX IF NOT EXISTS idx_transaction_user_type ON historique_transaction(user_id, type_transaction);

-- Composite index for phone transaction history
CREATE INDEX IF NOT EXISTS idx_transaction_phone ON historique_transaction(telephone_id, date_transaction DESC);

-- Index for date range queries
CREATE INDEX IF NOT EXISTS idx_transaction_date ON historique_transaction(date_transaction DESC);

-- Composite index for user, type, and date (covers most dashboard queries)
CREATE INDEX IF NOT EXISTS idx_transaction_user_type_date ON historique_transaction(user_id, type_transaction, date_transaction DESC);

-- Add comments to document the indexes
COMMENT ON INDEX idx_transaction_type IS 'Optimizes filtering by transaction type (achat, vente, retour)';
COMMENT ON INDEX idx_transaction_user_date IS 'Optimizes user-specific transaction lists sorted by date';
COMMENT ON INDEX idx_transaction_user_type IS 'Optimizes filtering transactions by user and type';
COMMENT ON INDEX idx_transaction_phone IS 'Optimizes phone transaction history queries';
COMMENT ON INDEX idx_transaction_date IS 'Optimizes date range queries';
COMMENT ON INDEX idx_transaction_user_type_date IS 'Optimizes dashboard queries with user, type, and date filters';

-- Verification query (optional - for manual testing)
-- EXPLAIN ANALYZE SELECT * FROM historique_transaction WHERE user_id = 'xxx' AND type_transaction = 'vente' ORDER BY date_transaction DESC LIMIT 50;
