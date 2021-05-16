command! DapToggleBreakpoint :lua require'dap'.toggle_breakpoint()<CR>
command! DapStepOut :lua require'dap'.step_out()<CR>
command! DapStepInto :lua require'dap'.step_into()<CR>
command! DapStepOver :lua require'dap'.step_over()<CR>
command! DapContinue :lua require'dap'.continue()<CR>
command! DapRunLast :lua require'dap'.run_last()<CR>
