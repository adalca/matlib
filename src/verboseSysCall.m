function result = verboseSysCall(sysCall)
% do the sysCall with some printout and timing, check that it finishes
% cleanly, and return the resulting output.

    sysCallTic = tic;
    fprintf('%s\n\n', sysCall);
    [status, result] = system(sysCall);
    assert(status == 0, 'syscall failed:\n%s\n%s', sysCall, result);
    fprintf(1, 'syscall done in %.2f sec\n', toc(sysCallTic));   
end
