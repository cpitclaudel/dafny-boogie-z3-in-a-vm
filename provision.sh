#!/usr/bin/env bash

export LOGDIR=/vagrant
export LOGFILE=$LOGDIR/provision.log
export DEBIAN_FRONTEND=noninteractive

echo "" > $LOGFILE
echo "* Starting; see ${LOGFILE} for details."

echo ""
echo '*********************************'
echo '***  Installing dependencies  ***'
echo '*********************************'

echo '* apt-get update'
sudo add-apt-repository -y ppa:ubuntu-elisp/ppa >> $LOGFILE 2>&1
sudo apt-get -y update >> $LOGFILE
echo '* apt-get install (VBox extensions)'
sudo apt-get -y install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 >> $LOGFILE
echo '* apt-get install (Dafny dependencies)'
sudo apt-get -y install unzip git mercurial emacs-snapshot mono-devel >> $LOGFILE
echo '* apt-get install (Dafny development and testing dependencies)'
sudo apt-get -y install python3 python3-pip monodevelop >> $LOGFILE
sudo apt-get -y install python3-matplotlib python3-numpy >> $LOGFILE
sudo pip3 install colorama chardet >> $LOGFILE

echo 'export TERM=xterm-256color' >> ~/.profile

echo ""
echo '*********************************'
echo '*** Downloading and building  ***'
echo '*********************************'

echo '* wget z3'
wget --quiet -O /tmp/z3.zip https://github.com/Z3Prover/z3/releases/download/z3-4.4.0/z3-4.4.0-x64-ubuntu-14.04.zip >> $LOGFILE
echo '* git clone boogie'
git clone --quiet --depth 1 https://github.com/boogie-org/boogie.git MSR/boogie >> $LOGFILE
echo '* hg clone dafny'
hg clone --quiet https://hg.codeplex.com/dafny MSR/dafny >> $LOGFILE

echo '* setup (z3)'
unzip -o /tmp/z3.zip -d ~/MSR >> $LOGFILE
mv -T ~/MSR/z3-4.4.0-x64-ubuntu-14.04 ~/MSR/z3 >> $LOGFILE

# cd z3 >> $LOGFILE 2>&1
# ./configure >> $LOGFILE 2>&1
# make -C build -j2 >> $LOGFILE 2>&1
# cd .. >> $LOGFILE 2>&1

echo '* setup (Boogie)'
cd ~/MSR/boogie
mozroots --import --sync >> $LOGFILE
wget --quiet https://nuget.org/nuget.exe >> $LOGFILE
mono ./nuget.exe restore Source/Boogie.sln >> $LOGFILE
xbuild /p:Configuration=Debug Source/Boogie.sln >> $LOGFILE
cp ~/MSR/z3/bin/z3 ~/MSR/boogie/Binaries/z3.exe >> $LOGFILE

echo '* setup (Dafny)'
cd ~/MSR/dafny
xbuild /p:Configuration=Debug Source/Dafny.sln >> $LOGFILE
ln -s ~/MSR/z3 ~/MSR/dafny/Binaries/z3 >> $LOGFILE

echo ""
echo '*********************************'
echo '***      Setting up Emacs     ***'
echo '*********************************'

echo '* fonts'
mkdir -p ~/.fonts >> $LOGFILE
wget --quiet -O ~/.fonts/symbola-monospace.ttf https://raw.githubusercontent.com/cpitclaudel/monospacifier/master/fonts/Symbola_monospacified_for_UbuntuMono.ttf >> $LOGFILE
wget --quiet -O /tmp/ubuntu-fonts.zip http://font.ubuntu.com/download/ubuntu-font-family-0.83.zip >> $LOGFILE
unzip -o /tmp/ubuntu-fonts.zip -d ~/.fonts/ >> $LOGFILE

echo '* Emacs configuration'
mkdir -p ~/.emacs.d/
cp /vagrant/init.el ~/.emacs.d/init.el

echo '* package install'
emacs --batch --load ~/.emacs.d/init.el \
      --eval "(package-refresh-contents)" \
      --eval "(package-install 'csharp-mode)" \
      --eval "(package-install 'boogie-friends)" \
      >> $LOGFILE 2>&1

echo '* PATH adjustments'
echo 'export PATH="$PATH:~/MSR/z3/bin:~/MSR/boogie/Binaries/:~/MSR/dafny/Binaries/"' >> ~/.profile

echo ""
echo '*********************************'
echo '***       Setup complete      ***'
echo '*********************************'

echo ""
echo 'Log into the VM using ‘vagrant ssh’. To start using Dafny, just open a ‘.dfy’ file in Emacs.'
