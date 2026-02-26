return {
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    keys = {
      { '<leader>rs', '<cmd>lua require("kulala").scratchpad()<cr>', desc = 'REST: Open scratchpad' },
      { '<leader>rr', '<cmd>lua require("kulala").run()<cr>', desc = 'REST: Run request' },
      { '<leader>ri', '<cmd>lua require("kulala").inspect()<cr>', desc = 'REST: Inspect request' },
      { '<leader>rt', '<cmd>lua require("kulala").toggle_view()<cr>', desc = 'REST: Toggle view' },
    },
  },
}
