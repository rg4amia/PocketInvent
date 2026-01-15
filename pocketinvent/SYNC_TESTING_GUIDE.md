# Synchronization & Offline Mode Testing Guide

## Prerequisites

- Device or simulator with internet connection
- Ability to toggle WiFi/cellular data on/off
- PocketInvent app installed and logged in
- Some test data (phones and transactions)

## Test Scenarios

### 1. Initial Load & Sync

**Steps:**
1. Launch the app with internet connection
2. Navigate to Dashboard
3. Observe the sync indicator in the app bar

**Expected Results:**
- ✅ App loads cached data immediately (fast display)
- ✅ Sync indicator shows blue "Synchronisation..." briefly
- ✅ Sync indicator changes to green "À l'instant" when complete
- ✅ Dashboard displays all financial metrics correctly

---

### 2. Real-time Synchronization

**Requirements:** Two devices or one device + web browser with Supabase dashboard

**Steps:**
1. Open app on Device A
2. On Device B (or Supabase dashboard), create a new transaction
3. Observe Device A without refreshing

**Expected Results:**
- ✅ New transaction appears automatically on Device A
- ✅ Financial metrics update automatically
- ✅ No manual refresh needed
- ✅ Sync indicator briefly shows "Synchronisation..."

---

### 3. Offline Mode Detection

**Steps:**
1. Open app with internet connection
2. Navigate to Dashboard
3. Turn off WiFi and cellular data
4. Observe the UI changes

**Expected Results:**
- ✅ Orange offline banner appears at top: "Mode hors ligne - Affichage des données en cache"
- ✅ Sync indicator shows orange "Hors ligne" badge
- ✅ Dashboard continues to display cached data
- ✅ All metrics remain visible and accurate

---

### 4. Offline Data Access

**Steps:**
1. With internet ON, navigate through app and view data
2. Turn OFF internet connection
3. Navigate to Dashboard
4. Change period filter (e.g., from "Ce mois" to "Cette semaine")
5. Navigate to Transactions list
6. Apply filters

**Expected Results:**
- ✅ Dashboard loads instantly from cache
- ✅ Period changes work correctly with cached data
- ✅ Transactions list displays cached data
- ✅ Filters work on cached data
- ✅ No error messages or crashes

---

### 5. Reconnection & Auto-Sync

**Steps:**
1. Start with app in offline mode (showing orange banner)
2. Turn internet connection back ON
3. Observe the sync behavior

**Expected Results:**
- ✅ Orange offline banner disappears
- ✅ Sync indicator shows blue "Synchronisation..."
- ✅ Automatic full sync occurs in background
- ✅ Sync indicator changes to green "À l'instant"
- ✅ Any server changes appear in the UI

---

### 6. Sync Indicator States

**Test each state:**

**Online & Synced:**
- Green badge with cloud_done icon
- Shows time since last sync:
  - "À l'instant" (< 1 minute)
  - "Il y a X min" (< 1 hour)
  - "Il y a Xh" (< 24 hours)
  - "DD/MM à HH:mm" (older)

**Syncing:**
- Blue badge with spinner
- Text: "Synchronisation..."

**Offline:**
- Orange badge with cloud_off icon
- Text: "Hors ligne"

---

### 7. Pull-to-Refresh

**Steps:**
1. On Dashboard, pull down to refresh
2. Observe sync behavior

**Expected Results:**
- ✅ Refresh indicator appears
- ✅ Full sync occurs
- ✅ Data updates if changes exist
- ✅ Sync indicator updates

---

### 8. Cache Persistence

**Steps:**
1. Use app with internet ON
2. View Dashboard and Transactions
3. Force close the app completely
4. Turn OFF internet
5. Reopen the app
6. Navigate to Dashboard

**Expected Results:**
- ✅ App opens successfully offline
- ✅ Cached data displays immediately
- ✅ Offline banner shows
- ✅ All previously viewed data is available

---

### 9. Period Filter with Cache

**Steps:**
1. Go offline
2. Open Dashboard
3. Change period filter multiple times:
   - Aujourd'hui
   - Cette semaine
   - Ce mois
   - Cette année
   - Personnalisée

**Expected Results:**
- ✅ Each period change recalculates metrics from cache
- ✅ Calculations are accurate
- ✅ No errors or loading issues
- ✅ Charts update correctly

---

### 10. Export While Offline

**Steps:**
1. Go offline
2. Navigate to Dashboard
3. Try to export to CSV
4. Try to export to PDF

**Expected Results:**
- ✅ Export works with cached data
- ✅ Files generate successfully
- ✅ Share dialog appears
- ✅ Exported data is accurate

---

## Performance Checks

### Load Time
- **First load (online):** < 2 seconds to show cached data
- **Background sync:** < 5 seconds for typical dataset
- **Offline load:** < 1 second (instant from cache)

### Memory Usage
- Monitor memory usage during sync
- Should not increase significantly
- No memory leaks after multiple syncs

### Battery Impact
- Real-time listeners should not drain battery excessively
- Test with app in background for extended period

---

## Edge Cases

### 1. Poor Connection
**Test:** Use slow/unstable network
- App should fall back to cache gracefully
- Sync should retry automatically
- No crashes or freezes

### 2. Large Dataset
**Test:** With 100+ phones and 500+ transactions
- Sync should complete successfully
- UI should remain responsive
- Cache should handle large data

### 3. Rapid Connection Changes
**Test:** Toggle WiFi on/off rapidly
- App should handle state changes gracefully
- No duplicate syncs
- Sync indicator updates correctly

### 4. Background/Foreground
**Test:** Switch app to background and back
- Real-time listeners should reconnect
- Sync should resume automatically
- No data loss

---

## Known Limitations

1. **Conflict Resolution:** Server data always wins (no merge strategy)
2. **Offline Writes:** Not supported - changes require internet
3. **Selective Sync:** All data syncs (no period-based filtering)
4. **Background Sync:** No platform background tasks (only when app is open)

---

## Troubleshooting

### Sync Not Working
1. Check internet connection
2. Verify user is logged in
3. Check Supabase credentials in .env
4. Look for errors in console logs

### Offline Mode Not Detected
1. Verify connectivity_plus package is installed
2. Check device permissions
3. Try airplane mode instead of just WiFi off

### Real-time Updates Not Appearing
1. Check Supabase real-time is enabled
2. Verify RLS policies allow real-time
3. Check console for subscription errors
4. Try restarting the app

### Cache Not Persisting
1. Verify Hive is initialized
2. Check storage permissions
3. Look for Hive errors in logs
4. Try clearing app data and re-caching

---

## Success Criteria

All tests should pass with:
- ✅ No crashes or errors
- ✅ Smooth user experience
- ✅ Accurate data display
- ✅ Proper sync indicators
- ✅ Fast load times
- ✅ Graceful offline handling

---

## Reporting Issues

When reporting sync/offline issues, include:
1. Device model and OS version
2. Internet connection type (WiFi/cellular)
3. Steps to reproduce
4. Console logs
5. Screenshots of sync indicator
6. Dataset size (number of phones/transactions)
