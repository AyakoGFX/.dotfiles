git clone https://github.com/neovim/neovim --depth 1

cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo

git checkout stable

make

sudo make install
