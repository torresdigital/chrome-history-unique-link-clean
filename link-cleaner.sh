#!/bin/bash

# Configuration & Log Setup
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$REAL_USER)
LOG_FILE="$HOME/chrome_purge_report.log"
echo "--- Chrome Purge Session: $(date) ---" > "$LOG_FILE"

# --- ANIMATION FUNCTION ---
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "\b${sp:i++%n:1}"
    done
}

clear
echo "======================================================="
echo "   DEEP CHROME MONITOR: LIVE PURGE & VERIFICATION"
echo "======================================================="

# --- STEP 1: UNLOCK DATABASES ---
echo -e "\n[1/4] SYSTEM PREPARATION"
echo -n "  >> Terminating browser processes... "
spinner &
SPIN_PID=$!
# Kill all Chrome/Chromium variants
sudo pkill -9 -x chrome 2>/dev/null
sudo pkill -9 -x chromium 2>/dev/null
sudo pkill -9 -x google-chrome 2>/dev/null
kill "$SPIN_PID" &>/dev/null
echo -e "\bDone. Databases unlocked."

# --- STEP 2: TARGET IDENTIFICATION ---
echo -e "\n[2/4] TARGET IDENTIFICATION"
echo "  >> Note: Keyword will match https, www, and subdomains."
read -p "  >> Enter domain to scrub (e.g., facebook.com): " TARGET_SITE
[[ -z "$TARGET_SITE" ]] && { echo "Aborted."; exit 1; }
QUERY="%$TARGET_SITE%"

# --- STEP 3: DEEP SCAN & PURGE ---
echo -e "\n[3/4] DEEP SCANNING: $USER_HOME"
echo "-------------------------------------------------------"

# Find every 'History' file in Home (handles Snap, Flatpak, Native)
echo -n "  >> Scanning for all profile databases... "
spinner &
SCAN_PID=$!
mapfile -t HISTORY_FILES < <(find "$USER_HOME" -name "History" -type f 2>/dev/null | grep -i "chrome\|chromium")
kill "$SCAN_PID" &>/dev/null
echo -e "\bFound ${#HISTORY_FILES[@]} file(s)."

for DB in "${HISTORY_FILES[@]}"; do
    DIR=$(dirname "$DB")
    PROF=$(basename "$DIR")
    
    echo -e "\nFILE: $DB"
    echo "PROFILE: $PROF" | tee -a "$LOG_FILE"
    
    # 1. Journal Cleanup
    rm -f "$DB-journal" "$DB-wal" 2>/dev/null

    # 2. Count Before
    BEFORE=$(sqlite3 "$DB" "SELECT count(*) FROM urls WHERE url LIKE '$QUERY';" 2>>"$LOG_FILE")
    echo "  >> Matches Found: $BEFORE" | tee -a "$LOG_FILE"

    if [ "$BEFORE" -gt 0 ]; then
        echo -n "  >> Executing Deep Purge... "
        spinner &
        PURGE_PID=$!
        
        # Deep SQL Wipe
        sqlite3 "$DB" <<EOF 2>>"$LOG_FILE"
DELETE FROM visits WHERE url IN (SELECT id FROM urls WHERE url LIKE '$QUERY');
DELETE FROM urls WHERE url LIKE '$QUERY';
DELETE FROM keyword_search_terms WHERE term LIKE '$QUERY';
DELETE FROM segment_usage WHERE segment_id IN (SELECT id FROM segments WHERE name LIKE '$QUERY');
VACUUM;
EOF
        kill "$PURGE_PID" &>/dev/null
        
        # 3. Self-Verification
        AFTER=$(sqlite3 "$DB" "SELECT count(*) FROM urls WHERE url LIKE '$QUERY';" 2>>"$LOG_FILE")
        if [ "$AFTER" -eq 0 ]; then
            echo -e "\bSUCCESS: Verified (0 matches remaining)." | tee -a "$LOG_FILE"
        else
            echo -e "\bFAILED: $AFTER entries could not be removed." | tee -a "$LOG_FILE"
        fi
    else
        echo "  >> Result: Database already clean." | tee -a "$LOG_FILE"
    fi

    # 4. Favicon Scrubbing
    if [ -f "$DIR/Favicons" ]; then
        sqlite3 "$DIR/Favicons" "DELETE FROM icon_mapping WHERE page_url LIKE '$QUERY'; VACUUM;" 2>/dev/null
        echo "  >> Site icons (Favicons) scrubbed." | tee -a "$LOG_FILE"
    fi

    # --- IMPLEMENTATION: PASSWORDS & AUTOFILL ---
    # Login Data (Passwords)
    if [ -f "$DIR/Login Data" ]; then
        sqlite3 "$DIR/Login Data" "DELETE FROM logins WHERE origin_url LIKE '$QUERY'; VACUUM;" 2>/dev/null
        echo "  >> Passwords for $TARGET_SITE removed from Login Data." | tee -a "$LOG_FILE"
    fi

    # Web Data (Autofill)
    if [ -f "$DIR/Web Data" ]; then
        sqlite3 "$DIR/Web Data" "DELETE FROM autofill WHERE name LIKE '$QUERY' OR value LIKE '$QUERY'; VACUUM;" 2>/dev/null
        echo "  >> Autofill entries for $TARGET_SITE removed from Web Data." | tee -a "$LOG_FILE"
    fi
done

# --- STEP 4: FINAL LOG & SYNC ---
echo -e "\n[4/4] COMPLETION & CLOUD SYNC"
echo "-------------------------------------------------------"
echo "  >> Opening Google My Activity for Cloud Deletion..."
xdg-open "https://myactivity.google.com" &>/dev/null &

echo -e "\n======================================================="
echo "   FINAL TASK LOG REPORT"
echo "======================================================="
cat "$LOG_FILE"
echo "======================================================="
echo "STATUS: Process complete. Detailed log saved to: $LOG_FILE"
echo "IMPORTANT: If history remains, delete it in the opened browser window."
echo "======================================================="
