
if [ ! -d $REMOTE_GIT_DIR ]; then
  mkdir -p $REMOTE_GIT_DIR
  cd $REMOTE_GIT_DIR
  git init
  mysqldump -h $REMOTE_HOST -P $REMOTE_PORT -u $REMOTE_USER -p"$REMOTE_PASS" $REMOTE_DB > dump.sql
  git add dump.sql
  git commit -m "Initial dump added `date +"%Y-%m-%d %H:%M:%S"`"
fi