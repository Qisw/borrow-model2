function n79S = nlsy79_targets_load(cS)

n79S = load(cS.nlsy79Fn);
n79S = n79S.all_targets;

% Need to rename all "byses" fields into "byinc"
fnV = fieldnames(n79S);
for i1 = 1 : length(fnV)
   oldName = fnV{i1};
   if ~isempty(strfind(oldName, 'byses'))
      newName = strrep(oldName, 'byses', 'byinc');
      n79S.(newName) = n79S.(oldName);
      n79S = rmfield(n79S, oldName);
   end
end


end