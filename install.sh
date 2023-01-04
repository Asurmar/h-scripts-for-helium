#
# Repository: https://github.com/Asurmar/hscripts-for-helium
#
# Description: This script installs hscripts
#
# Compatibility:
# Milesight     +
# Panther       +
# Balena-based:
#   Sensecap    
#   Nebra       +

debug=false                       # set this to "true" for additional debugging
targetdir=/usr/local/sbin
targetdirfull=$targetdir
#targetdircopyto=$targetdir
giturl=https://github.com/Asurmar/hscripts-for-helium/raw/main/
gitfile=hscripts.tar.gz
rootmode=
overlaymode=none
lowerdir=
shellprofile=
shellprofilepath=
remount=false

[ $debug = true ] && echo Debug: Target dir = $targetdir

rootmode=$(mount|grep " / "|awk '{print $6}'|awk -F "," '{print $1}'|sed "s/(//")
[ $debug = true ] && echo Debug: Root filesystem mode: $rootmode
if [ $rootmode = ro ]; then
  [ $debug = true ] && echo Debug: Read-only filesystem, detecting overlay lowerdir.
  remount=true
  overlaymode=$(mount|grep -i 'overlay on / type overlay'|awk '{print $6}'|awk -F "," '{print $1}'|sed 's/(//')
  [ $debug = true ] && echo Debug: Overlay mode = $overlaymode
  if [ -x "$(command -v balena)" ]; then lowerdir=/mnt/sysroot/active$(mount|egrep -o 'lowerdir=[^, ]*'|sed 's/lowerdir=//')
                                    else echo Unknown containerization engine, exiting; fi
  [ $debug = true ] && echo Debug: Overlay lowerdir = $lowerdir
  [ $debug = true ] && echo Debug: Remount = $remount
  targetdirfull=$lowerdir$targetdir
  targetdircopyto=$targetdirfull
  [ $debug = true ] && echo Debug: Full target dir = $targetdirfull
  [ $debug = true ] && echo Debug: Target dir copy to = $targetdirfull
  mount -o remount /
fi

### Target directory creation
if [ ! -d $targetdir ]; then
  [ $debug = true ] && echo Debug: Directory $targetdir does not exist
  mkdir -p $targetdirfull && { echo Creating directory: $targetdir; echo; }
  [ $remount = true ] && mount -o remount /
fi

### Downloading file from github
[ $debug = true ] && echo Debug: Overlay mode = $overlaymode
if [ $overlaymode = ro ]; then
  cd /mnt/data
  [ $debug = true ] && echo Debug: Current dir: $(pwd)
fi
[ $debug = true ] && echo
echo Downloading from github repository https://github.com/Asurmar/hscripts-for-helium:
wget -O $gitfile $giturl$gitfile || { echo Failed to download $giturl$gitfile, exiting; exit 6; }
echo

### Extracting and installing files
echo Installing in directory: $targetdir
files=$(tar -tzf $gitfile)
[ $debug = true ] && echo Debug: List of files: $files
for file in $files; do
  [ $debug = true ] && echo Debug: Current file: $file
  tar -xzvf $gitfile $file > /dev/null || echo Error extracting file: $file
  mv $file $targetdirfull
  [ -f $targetdir/$file ] && echo File $file installed successfully.
done
rm $gitfile
echo Installation complete.
[ $remount = true ] && mount -o remount /
[ $debug = true ] && ls -l $targetdir 
echo

### Verifying PATH variable
[ $debug = true ] && echo Debug: PATH variable: $PATH
echo $PATH|egrep -o "^$targetdir:|:$targetdir:|:$targetdir$" >/dev/null
inpath=$?
[ $debug = true ] && echo Debug: inpath = $inpath
if [ $inpath -eq 0 ]; then
  [ $debug = true ] && echo Debug: $targetdir is in PATH, nothing to do, exiting.
  exit 0
fi

###
### If targetdir is not in PATH
###

### Shell detection
[ $debug = true ] && echo Debug: Your shell is $SHELL
case $SHELL in
  /bin/sh)   shellprofile=.profile;;
  /bin/ash)  shellprofile=.profile;;
  /bin/dash) shellprofile=.profile;;
  /bin/bash) shellprofile=.bashrc;;
  *)         echo Unknown shell, exiting; exit 6;;
esac
[ $debug = true ] && echo Debug: Shell profile is $shellprofile

### Shell profile path
if [ $rootmode = ro ]; then
  shellprofilepath=$lowerdir$HOME/$shellprofile
  [ $remount = true ] && mount -o remount /
elif [ $rootmode = rw ]; then
  shellprofilepath=$HOME/$shellprofile
fi
[ $debug = true ] && echo Debug: Full path to shell profile file: $shellprofilepath

if [ ! -f $shellprofilepath ]; then
  [ $debug = true ] && echo Debug: Shell profile file: $shellprofile does NOT exist
  touch $shellprofilepath && echo Shell profile created: $HOME/$shellprofile
  [ $remount = true ] && mount -o remount /                               
fi
echo "export PATH=\$PATH:$targetdir" >> $shellprofilepath && echo Added $targetdir to \$PATH variable, for scripts to work you MUST do one of 2 things:
echo "      1) logoff and logon again"
echo "      2) run this command:"
echo "            export PATH=\$PATH:$targetdir"
