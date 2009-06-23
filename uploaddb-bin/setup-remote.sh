
if [ ${REMOTE_CONFIG:-X} == ${REMOTE_CONFIG:-Y} ]; then
  source $REMOTE_CONFIG
fi

if [ ! -d $REMOTE_WD ]; then
  echo "Creating remote git repo"
  mkdir $REMOTE_WD
  cd $REMOTE_WD
  git init
else
  cd $REMOTE_WD
  BRANCHES=`git branch -l`
  if [[ $BRANCHES =~ master ]]; then
    echo "We have a working remote git repo"
  else
    echo "Initializing remote git repo"
    git init
  fi
fi

