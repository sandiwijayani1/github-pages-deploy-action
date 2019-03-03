#!/bin/sh -l
if [ -z "$BRANCH" ]
then
  echo "You must provide the action with a branch name."
  exit 1
fi

if [ -z "$FOLDER" ]
then
  echo "You must provide the action with the folder name in the repository where your compiled page lives."
fi

# Installs Git.
apt-get update && \
apt-get install -y git && \

# Re-directs to the the Github workspace.
cd $GITHUB_WORKSPACE && \

# Configures Git and checks out the base branch.
git config --global user.email "${COMMIT_EMAIL:-gh-pages-deploy@jives.dev}" && \
git config --global user.name "${COMMIT_NAME:-Github Pages Deploy}" && \
git checkout master && \
git push $GITHUB_REPOSITORY $BRANCH:$BRANCH && \

# Builds the project if applicable.
if [ -z "$BUILD_SCRIPT" ]
then
  $BUILD_SCRIPT && \
fi

# Commits the data to Github.
git add -f $FOLDER && 
git commit -m "Deploying $(date +"%T")" && \
git push origin `git subtree split --prefix $FOLDER master`:$BRANCH --force

