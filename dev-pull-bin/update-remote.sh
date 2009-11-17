NAME=`whoami`
MUTEX="/tmp/${NAME}-dpmutex-${REMOTE_DB}";
NOW=`date '+%s'`
if [ "${REMOTE_PROC_DB-n}" != "n" ]; then
  MUTEX="/tmp/${NAME}-dpmutex-${REMOTE_PROC_DB}";
fi

while [ -f $MUTEX ]; do
  if [ -f $MUTEX ]; then
    THEN=`cat $MUTEX`
    DELTA=$((NOW-THEN))
    if [ $DELTA -gt 3600 ]; then # 1h = too long
      echo "Other-dev pull took too long, going ahead anyway"
      date '+%s' > $MUTEX
    else
      echo "Waiting for other dev-pull to finish..."
      sleep 5
    fi
  fi
done

if [ ! -f $MUTEX ]; then
  date '+%s' > $MUTEX
fi

cd $REMOTE_GIT_DIR
echo "Dumping database"
mysqldump -h $REMOTE_HOST -P $REMOTE_PORT -u $REMOTE_USER -p"$REMOTE_PASS" $REMOTE_DB > dump.sql

if [ "${REMOTE_PROC_DB-n}" != "n" ]; then
  echo "Emptying processing database"
  mysqldump -h $REMOTE_PROC_HOST -P $REMOTE_PROC_PORT -u $REMOTE_PROC_USER -p"$REMOTE_PROC_PASS" --add-drop-table --force --no-data $REMOTE_PROC_DB | grep ^DROP | mysql -h $REMOTE_PROC_HOST -P $REMOTE_PROC_PORT -u $REMOTE_PROC_USER -p"$REMOTE_PROC_PASS" $REMOTE_PROC_DB
  echo "Loading data into processing database"
  mysql -h $REMOTE_PROC_HOST -P $REMOTE_PROC_PORT -u $REMOTE_PROC_USER -p"$REMOTE_PROC_PASS" $REMOTE_PROC_DB < dump.sql
  echo "Processing..."
  echo "UPDATE ${TABLE_PREFIX}users SET pass=MD5('pass') WHERE uid!=0; TRUNCATE TABLE ${TABLE_PREFIX}cache; TRUNCATE TABLE ${TABLE_PREFIX}cache_block; TRUNCATE TABLE ${TABLE_PREFIX}cache_content; TRUNCATE TABLE ${TABLE_PREFIX}cache_filter; TRUNCATE TABLE ${TABLE_PREFIX}cache_form; TRUNCATE TABLE ${TABLE_PREFIX}cache_menu; TRUNCATE TABLE ${TABLE_PREFIX}cache_page; TRUNCATE TABLE ${TABLE_PREFIX}cache_update; TRUNCATE TABLE ${TABLE_PREFIX}cache_views; TRUNCATE TABLE ${TABLE_PREFIX}cache_views_data;" |
    mysql -h $REMOTE_PROC_HOST -P $REMOTE_PROC_PORT -u $REMOTE_PROC_USER -p"$REMOTE_PROC_PASS" $REMOTE_PROC_DB;
  echo "Dumping processing database"
  mysqldump -h $REMOTE_PROC_HOST -P $REMOTE_PROC_PORT -u $REMOTE_PROC_USER -p"$REMOTE_PROC_PASS" $REMOTE_PROC_DB > dump.sql
fi

echo "Committing the new dump"
git add dump.sql
git commit -m "New dump added `date +"%Y-%m-%d %H:%M:%S"`"

rm $MUTEX