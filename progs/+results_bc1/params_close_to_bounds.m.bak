function params_close_to_bounds(setNo, expNo)

cS = const_bc1(setNo, expNo);
paramS = param_load_bc1(cS.setNo, cS.expNo);

outFn = fullfile(cS.paramDir, 'close_to_bounds.txt');
fp = fopen(outFn, 'w');
cS.pvector.show_close_to_bounds(paramS, cS.doCalV, fp);
fclose(fp);


type(outFn);

end