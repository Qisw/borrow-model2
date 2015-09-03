function symbol_table(setNo)
% Generate latex preamble with notation

cS = const_bc1(setNo);

symS = helper_bc1.symbols;


%% Calibrated parameters
% Each potentially calibrated parameter gets a newcommand

for i1 = 1 : cS.pvector.np
   nameStr = cS.pvector.nameV{i1};
   if length(nameStr) > 1
      % Does it already exist?
      if isempty(symS.retrieve(nameStr))
         ps = cS.pvector.retrieve(nameStr);
         %results_bc1.preamble_add(nameStr,  ps.symbolStr,  ps.descrStr,  cS);
         symS = symS.add(nameStr, ps.symbolStr);
      end
   end
end


symS.preamble_write(cS.symbolFn);


end