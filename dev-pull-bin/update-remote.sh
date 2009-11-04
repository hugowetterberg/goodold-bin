
cd $REMOTE_GIT_DIR
mysqldump -h $REMOTE_HOST -P $REMOTE_PORT -u $REMOTE_USER -p"$REMOTE_PASS" $REMOTE_DB > dump.sql
git add dump.sql
git commit -m "New dump added `date +"%Y-%m-%d %H:%M:%S"`"