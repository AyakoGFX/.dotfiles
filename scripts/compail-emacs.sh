git clone https://git.savannah.gnu.org/git/emacs.git --depth 1

./autogen.sh

./configure --with-native-compilation

make -j$(nproc)

sudo make install
