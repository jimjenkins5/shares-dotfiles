# get user name if different from logged in name (i.e. you are su'ing)
function get_user_name_if_different() {
   if [ ! "${USER}" == "${LOGNAME}" ]; then
      echo "${USER}@"
   else
      echo ""
   fi
}

# get current branch in git repo
function parse_git_branch() {
   BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
   if [ ! "${BRANCH}" == "" ]; then
     STAT=`parse_git_dirty`
     echo ":${BRANCH}${STAT}"
   else
      echo ""
   fi
}

# get current status of git repo
function parse_git_dirty {
   status=`git status 2>&1 | tee`
   dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
   untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
   ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
   newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
   renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
   deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
   bits=''
   if [ "${renamed}" == "0" ]; then
      bits=">${bits}"
   fi
   if [ "${ahead}" == "0" ]; then
      bits="*${bits}"
   fi
   if [ "${newfile}" == "0" ]; then
      bits="+${bits}"
   fi
   if [ "${untracked}" == "0" ]; then
      bits="?${bits}"
   fi
   if [ "${deleted}" == "0" ]; then
      bits="x${bits}"
   fi
   if [ "${dirty}" == "0" ]; then
      bits="!${bits}"
   fi
   if [ ! "${bits}" == "" ]; then
      echo " ${bits}"
   else
      echo " "
   fi
}

# export both functions and PS1 to make them available in su
export -f parse_git_dirty
export -f parse_git_branch
export -f get_user_name_if_different

ps1_username_color="\[\033[38;5;41m\]"
ps1_dir_color="\[\033[38;5;33m\]"
ps1_branch_color="\[\033[38;5;250m\]"
ps1_no_color="\[\e[m\]"

export PS1="$ps1_username_color\`get_user_name_if_different\`\h:$ps1_dir_color\W$ps1_branch_color\`parse_git_branch\`$ps1_no_color\\n\$ "
