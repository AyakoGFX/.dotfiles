return {
    "mbbill/undotree",

    config = function() 
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndoTree" })
    end
}

      -- vim.keymap.set("n", "<C-f>", builtin.find_files, { desc = "Find files (Ctrl + F)" })
