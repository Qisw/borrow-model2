function [outS, entryS] = load_income_iq_college(sourceFn, setNo)
% Load college entry / grad rates by [iq, yp]
%{
Using csv files for each source
Not all years have graduation rates

IN
   sourceFn
      e.g. 'updegraff 1936.csv'

OUT
   entry_qyM, grad_qyM
      entry and graduation rates (not conditional on entry)
      by [iq, yp] quartile
   mass_qyM
      mass of HSG in each cell

Plot raw and interpolated data +++
%}

error('Not updated for new xls files');

cS = const_bc1(setNo);
nq = length(cS.iqUbV);
nYp = length(cS.ypUbV);


%% Load xls files

% gradDir = '/Users/lutz/Dropbox/borrowing constraints/data/income x iq x college grad';
% entryDir = '/Users/lutz/Dropbox/borrowing constraints/data/income x iq x college';

% Number of persons in each [s,q,y] group
%entryS = load_historical_table(fullfile(cS.studyEntryDir, sourceFn), cS);

% Graduation rates are still conditional on entry
gradFn = fullfile(cS.studyGradDir, sourceFn);
if exist(gradFn, 'file')
   gradS  = load_table(gradFn, cS);
else
   gradS = [];
end


%%  Consistency check

frac_yV = sum(entryS.perc_qyM);
cumFrac_yV = cumsum(frac_yV);
diffV = cumFrac_yV(:) - entryS.ypUbV;
if any(abs(diffV) > 0.05) 
   fprintf('%s \n', sourceFn);
   error_bc1('Inconsistent', cS);
end

frac_qV = sum(entryS.perc_qyM, 2);
cumFrac_qV = cumsum(frac_qV);
diffV = cumFrac_qV(:) - entryS.iqUbV;
if any(abs(diffV) > 0.05) 
   fprintf('%s \n', sourceFn);
   error_bc1('Inconsistent', cS);
end



%% Interpolate to match cS.iqUbV and cS.ypUbV

mass_qyM  = interpolate(entryS.perc_qyM, entryS.iqUbV, entryS.ypUbV, cS);
outS.mass_qyM  = mass_qyM ./ sum(mass_qyM(:));

outS.entry_qyM = interpolate(entryS.perc_coll_qyM, entryS.iqUbV, entryS.ypUbV, cS);
validateattributes(outS.entry_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   '<', 1})

if ~isempty(gradS)
   outS.grad_qyM  = interpolate(gradS.prob_grad_qyM, gradS.iqUbV, gradS.ypUbV, cS);
   % Make prob grad not conditional on entry
   outS.grad_qyM = outS.grad_qyM .* outS.entry_qyM;
   validateattributes(outS.grad_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 1})
else
   outS.grad_qyM = [];
end



%%  Construct marginal distributions

[outS.entry_qV, outS.entry_yV] = helper_bc1.marginals(outS.entry_qyM, outS.mass_qyM, cS);
validateattributes(outS.entry_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   '<', 1, 'size', [nq, 1]})
validateattributes(outS.entry_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   '<', 1, 'size', [nYp, 1]})

if ~isempty(gradS)
   [outS.grad_qV,  outS.grad_yV] = helper_bc1.marginals(outS.grad_qyM, outS.mass_qyM, cS);
   validateattributes(outS.grad_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 0.9, 'size', [nq, 1]})
   validateattributes(outS.grad_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 0.9, 'size', [nYp, 1]})
end


end





