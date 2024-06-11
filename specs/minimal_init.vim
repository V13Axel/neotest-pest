set packpath=./packpath
set rtp+=.
set rtp+=./packpath/plenary.nvim
packadd! plenary.nvim
packadd! neotest
packadd! neotest-plenary
packadd! nvim-nio
runtime! plugin/plenary.vim
