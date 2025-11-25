return {
  'NMAC427/guess-indent.nvim',
  { 'lewis6991/gitsigns.nvim', opts = {
      signs = { add={text='+'}, change={text='~'}, delete={text='_'}, topdelete={text='‾'}, changedelete={text='~'} },
    }
  },
  { 'folke/todo-comments.nvim', event='VimEnter', dependencies={'nvim-lua/plenary.nvim'}, opts={ signs = false } },
}
