function cmdStr = command(solverStr, setNoV, expNo)
% Create command for submitting a set of jobs on kure
%{
Also copies to clipboard, if run on a local machine

%}

cS = const_bc1(setNoV(1), expNo);

% Default solver
if isempty(solverStr)
   solverStr = 'fminsearch';
end

if length(setNoV) == 1
   logStr = sprintf('set%i_%i.out', setNoV(1), expNo);
   setStr = sprintf('%i', setNoV(1));
else
   % Running multiple
   logStr = sprintf('set%i%i.out', setNoV(1), setNoV(end));

   % Make a string for set numbers
   if isequal(setNoV(:)', setNoV(1) : setNoV(end))
      % Sequential
      setStr = sprintf('%i:%i', setNoV(1), setNoV(end));
   else
      setStr = sprintf('%i,', setNoV);
      setStr = [ '[', setStr(1 : (end-1)), ']' ];
   end
end


perturbGuess = 0;
mFileStr = sprintf('kure_bc1(''%s'',%i,%s,%i)', solverStr, perturbGuess, setStr, expNo);

% No of cpus
if cS.kureS.parallel
   nCpus = cS.kureS.nNodes;
else
   nCpus = 1;
end

cmdStr = kure_lh.command(mFileStr, logStr, nCpus);
   
end