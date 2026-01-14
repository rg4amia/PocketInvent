# Database Migrations

This directory contains SQL migration scripts for the PocketInvent database.

## How to Apply Migrations

### Option 1: Using Supabase Dashboard (Recommended)

1. Log in to your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy the contents of the migration file
4. Paste and execute the SQL script
5. Verify the changes in the Table Editor

### Option 2: Using Supabase CLI

```bash
# If you have Supabase CLI installed
supabase db push
```

### Option 3: Manual Execution

If you have direct database access:

```bash
psql -h your-db-host -U postgres -d postgres -f migrations/add_stock_status_to_telephone.sql
```

## Migration Files

### add_stock_status_to_telephone.sql

**Date:** 2026-01-14  
**Purpose:** Add stock status tracking to support financial dashboard and transaction workflow

**Changes:**
- Adds `stock_status` column to `telephone` table
- Creates indexes for optimized queries
- Updates existing data with default status 'enStock'

**Requirements:** 4.1, 4.2, 4.3, 4.4

**Validation:**
After applying the migration, verify with:
```sql
-- Check column exists
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'telephone' AND column_name = 'stock_status';

-- Check indexes
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'telephone' AND indexname LIKE 'idx_telephone_%';

-- Check data
SELECT stock_status, COUNT(*) as count 
FROM telephone 
GROUP BY stock_status;
```

## Rollback

If you need to rollback this migration:

```sql
-- Remove indexes
DROP INDEX IF EXISTS idx_telephone_stock_status;
DROP INDEX IF EXISTS idx_telephone_user_status;
DROP INDEX IF EXISTS idx_telephone_date_status;

-- Remove column
ALTER TABLE telephone DROP COLUMN IF EXISTS stock_status;
```

## Notes

- Always backup your database before applying migrations
- Test migrations in a development environment first
- The `stock_status` column uses a CHECK constraint to ensure only valid values: 'enStock', 'vendu', 'retourne'
- Existing phones are automatically set to 'enStock' status
