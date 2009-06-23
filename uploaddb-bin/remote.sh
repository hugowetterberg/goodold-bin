
if [ ${REMOTE_CONFIG:-X} == ${REMOTE_CONFIG:-Y} ]; then
  source $REMOTE_CONFIG
fi

cd $REMOTE_WD

echo 'Bringing database dump up to date on the remote'
REMOTE=`git branch -l`
if [[ $REMOTE =~ $REMOTE_NAME ]]; then
  git merge master
else
  git checkout -b $REMOTE_NAME master
fi


echo 'Emptying remote database'
mysqldump -u $REMOTE_USER -p"$REMOTE_PASS" --add-drop-table --force --no-data $REMOTE_DB | grep ^DROP | mysql -u $REMOTE_USER -p"$REMOTE_PASS" $REMOTE_DB

echo 'Importing database dump inte remote database'
cat dbdump.sql | mysql -u $REMOTE_USER -p"$REMOTE_PASS" $REMOTE_DB
