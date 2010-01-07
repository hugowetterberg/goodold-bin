
if [ ! -d $REMOTE_GIT_DIR ]; then
  mkdir -p $REMOTE_GIT_DIR
fi

if [ ! -d $REMOTE_GIT_DIR/.git ]; then
  cd $REMOTE_GIT_DIR
  git init
fi