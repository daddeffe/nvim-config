local lazy = require 'pack.lazy'

lazy.by_cmd('magma-nvim', 'MagmaInit', nil, 'MagmaInit')
lazy.by_key('magma-nvim', 'n', '<leader>ji', function() end, function() vim.cmd 'MagmaInit' end, { desc = '[J]upyter [I]nit' })
lazy.by_key('magma-nvim', 'n', '<leader>jd', function() end, function() vim.cmd 'MagmaDeinit' end, { desc = '[J]upyter [D]einit' })
lazy.by_key('magma-nvim', 'n', '<leader>jr', function() end, function() vim.cmd 'MagmaEvaluateLine' end, { desc = '[J]upyter [R]un line' })
lazy.by_key('magma-nvim', 'x', '<leader>jr', function() end, function() vim.cmd 'MagmaEvaluateVisual' end, { desc = '[J]upyter [R]un selection' })
lazy.by_key('magma-nvim', 'n', '<leader>jc', function() end, function() vim.cmd 'MagmaReevaluateCell' end, { desc = '[J]upyter [C]ell re-evaluate' })
lazy.by_key('magma-nvim', 'n', '<leader>jo', function() end, function() vim.cmd 'MagmaShowOutput' end, { desc = '[J]upyter [O]utput' })
lazy.by_key('magma-nvim', 'n', '<leader>jx', function() end, function() vim.cmd 'MagmaDelete' end, { desc = '[J]upyter delete cell' })
