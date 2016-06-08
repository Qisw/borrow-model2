function error_bc1(msgV, cS)
% Error with options

if isempty(cS)
   cS = const_bc1(7);
end

if iscell(msgV)
   warning('Error encountered');
   for i1 = 1 : length(msgV)
      fprintf(msgV{i1});
      fprintf('\n');
   end
   
else
   warning(msgV);
end

if cS.pauseOnError == 1
   keyboard;
   
else
   error('Terminating program');
end


end