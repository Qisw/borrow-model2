function schoolS = school_targets(tgS, cS)
% Add targets for schooling by [iq, yp]
%{
Graduation fractions are NOT conditional on entry

Currently only nlsy79 is up to date +++++
%}

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);


% *****  Required fields

% Frac(s | c)
schoolS.frac_scM = nan(cS.nSchool, cS.nCohorts);

% Fraction enter / graduate by IQ
%  frac grad not conditional on entry
schoolS.fracEnter_qcM = nan([nIq, cS.nCohorts]);
schoolS.fracGrad_qcM  = nan([nIq, cS.nCohorts]);
% Frac at least HSG | q
schoolS.fracHsg_qcM   = nan([nIq, cS.nCohorts]);

% Same by yp
schoolS.fracEnter_ycM = nan([nYp, cS.nCohorts]);
schoolS.fracGrad_ycM  = nan([nYp, cS.nCohorts]);
schoolS.fracHsg_ycM   = nan([nYp, cS.nCohorts]);

% Fraction enter / grad by [iq, yp, cohort]
%  conditional on HSG
schoolS.fracEnter_qycM = nan([nIq, nYp, cS.nCohorts]);
schoolS.fracGrad_qycM  = nan([nIq, nYp, cS.nCohorts]);
schoolS.fracHsg_qycM = nan([nIq, nYp, cS.nCohorts]);

% Mass (HSG+, q, y). Sums to 1 for each cohort
schoolS.massHsgPlus_qycM = nan([nIq, nYp, cS.nCohorts]);


% ****** Optional fields
% Used to construct the others for some datasets

% Fraction by schooling
%  If available, that's the only info needed
schoolS.frac_sqycM = nan([cS.nSchool, nIq, nYp, cS.nCohorts]);

% Fraction by [s,q]. Sum to 1 for each cohort
schoolS.frac_sqcM = nan([cS.nSchool, nIq, cS.nCohorts]);
schoolS.frac_sycM = nan([cS.nSchool, nYp, cS.nCohorts]);


%%  Nlsy79
% In original file and in output: frac grad not conditional on entry

%  Load file with all NLSY79 targets
n79S = data_bc1.nlsy79_targets_load(cS);
ic = tgS.icNlsy79;

frac_sqyM = nan(cS.nSchool, nIq, nYp);
frac_sqyM(cS.iHSD, :, :) = n79S.hsd_share_byinc_and_byafqt';
frac_sqyM(cS.iHSG, :, :) = n79S.hsg_share_byinc_and_byafqt';
frac_sqyM(cS.iCD, :, :)  = n79S.cd_share_byinc_and_byafqt';
frac_sqyM(cS.iCG, :, :)  = n79S.cg_share_byinc_and_byafqt';
validateattributes(frac_sqyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
   '<=', 1})
frac_sqyM = frac_sqyM ./ sum(frac_sqyM(:));

schoolS.frac_sqycM(:,:,:,ic) = frac_sqyM;

% Compute marginals implied by this
schoolS = marginals_from_sqy(ic, schoolS, cS);




%%  Early cohorts

% Needs updating +++++

for iCohort = 1 : 2
   bYear = cS.bYearV(iCohort);
   if abs(bYear - 1940) < 3
      % Project talent
      dataFn = 'flanagan 1971.csv';   
   elseif abs(bYear - 1915) < 3
      % Updegraff
      dataFn = 'updegraff_quartiles.csv'; 
   else
      error('Invalid');
   end
   
   loadS = data_bc1.load_income_iq_college(dataFn, cS.setNo);
   
   schoolS.massHsgPlus_qycM(:,:,iCohort) = loadS.mass_qyM ./ sum(loadS.mass_qyM(:));

   schoolS.fracEnter_qycM(:,:,iCohort) = loadS.entry_qyM;
   schoolS.fracEnter_qcM(:,iCohort) = loadS.entry_qV;
   schoolS.fracEnter_ycM(:,iCohort) = loadS.entry_yV;
   if ~isempty(loadS.grad_qyM)
      schoolS.fracGrad_qycM(:,:,iCohort)  = loadS.grad_qyM;
      schoolS.fracGrad_qcM(:,iCohort) = loadS.grad_qV;
      schoolS.fracGrad_ycM(:,iCohort) = loadS.grad_yV;
   end
end

% 
% % HSB data, hsb_fam_income.xlsx
% fracEnter_yqM = [0.1910305	0.3404084	0.4616973	0.7431248
%    0.2746048	0.3476628	0.5838453	0.8174849
%    0.3067916	0.4374966	0.6217784	0.8587366
%    0.2960698	0.5814796	0.7817845	0.9273478];
% % Fraction graduate conditional on entry
% fracGrad_yqM = [0.1987562	0.1296711	0.4773349	0.6385519
%    0.0779666	0.3380288	0.5016366	0.7053534
%    0.1137461	0.3146327	0.5340976	0.7627105
%    0.0291045	0.2856211	0.5979195	0.8423696];
% fracHsgPlus_yqM = 1 - fracEnter_yqM;
% fracCG_yqM  = fracEnter_yqM .* fracGrad_yqM;
% fracCD_yqM  = 1 - fracHsgPlus_yqM - fracCG_yqM;
% schoolS.fracS_qycM(cS.iHSG, :, :, icHSB) = fracHsgPlus_yqM';
% schoolS.fracS_qycM(cS.iCD,  :, :, icHSB) = fracCD_yqM';
% schoolS.fracS_qycM(cS.iCG,  :, :, icHSB) = fracCG_yqM';
% 
% validateattributes(schoolS.fracS_qycM(:,:,:,icHSB), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%    '>', 0', '<', 1, 'size', [cS.nSchool, nIq, nYp]})




%% Validation

for iCohort = 1 : cS.nCohorts
   if ~isnan(schoolS.frac_sqycM(1,1,1,iCohort))
      xM = schoolS.frac_sqycM(:,:,:,iCohort);
      validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
         '<', 1, 'size', [cS.nSchool, nIq, nYp]})
      pSum = sum(xM(:));
      if abs(pSum - 1) > 1e-6
         error('Probs do not sum to 1');
      end
   end
   if ~isnan(schoolS.fracEnter_qcM(1,iCohort))
      validateattributes(schoolS.fracEnter_qcM(:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         'positive', '<', 0.9})
   end
   if ~isnan(schoolS.fracGrad_qcM(1,iCohort))
      validateattributes(schoolS.fracGrad_qcM(:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         'positive', '<', 0.8})
   end
   
%    % Check consistency of marginals with joint distribution
   if ~isnan(schoolS.fracEnter_qycM(1,1,iCohort))  &&  ~isnan(schoolS.massHsgPlus_qycM(1,1,iCohort))
      [fracEnter_qV, fracEnter_yV] = ...
         helper_bc1.marginals(schoolS.fracEnter_qycM(:,:,iCohort), schoolS.massHsgPlus_qycM(:,:,iCohort), cS.dbg);
      if ~check_lh.approx_equal(fracEnter_qV, schoolS.fracEnter_qcM(:,iCohort), 1e-2, [])
         error('fracEnter_qV does not match');
      end
      if ~check_lh.approx_equal(fracEnter_yV, schoolS.fracEnter_ycM(:,iCohort), 1e-2, [])
         error('fracEnter_yV does not match');
      end
   end
   
   if ~isnan(schoolS.fracGrad_qycM(1,1,iCohort))  &&  ~isnan(schoolS.massHsgPlus_qycM(1,1,iCohort))
      [fracGrad_qV, fracGrad_yV] = ...
         helper_bc1.marginals(schoolS.fracGrad_qycM(:,:,iCohort), schoolS.massHsgPlus_qycM(:,:,iCohort), cS.dbg);
      if ~check_lh.approx_equal(fracGrad_qV, schoolS.fracGrad_qcM(:,iCohort), 1e-2, [])
         error('fracGrad_qV does not match');
      end
      if ~check_lh.approx_equal(fracGrad_yV, schoolS.fracGrad_ycM(:,iCohort), 1e-2, [])
         error('fracGrad_yV does not match');
      end
   end
end




%% Regress college entry on [iq, yp] groups
% Original data and quartiles
% Weighted and unweighted

schoolS.betaIq_cV = nan(cS.nCohorts, 1);
schoolS.betaYp_cV = nan(cS.nCohorts, 1);

for iCohort = 1 : cS.nCohorts
   if ~isnan(schoolS.fracEnter_qycM(1,1,iCohort))
      if cS.dataS.regrIqYpWeighted
         wt_qyM = sqrt(schoolS.massHsgPlus_qycM(:,:,iCohort));
      else
         wt_qyM = [];
      end

      [schoolS.betaIq_cV(iCohort), schoolS.betaYp_cV(iCohort)] = ...
         results_bc1.regress_qy(schoolS.fracEnter_qycM(:,:,iCohort), wt_qyM, ...
         cS.iqUbV(:), cS.ypUbV(:), cS.dbg);
   end
end


   

end


%% Marginals implied by mass by [s,q,y]
function schoolS = marginals_from_sqy(iCohort, schoolS, cS)
   dbg = cS.dbg;
   pmS = stats_lh.ProbMatrix3D(schoolS.frac_sqycM(:,:,:,iCohort));
   schoolS.frac_scM(:, iCohort) = pmS.prob_x(dbg);
   schoolS.frac_sqcM(:,:,iCohort) = pmS.prob_xy(dbg);
   schoolS.frac_sycM(:,:,iCohort) = pmS.prob_xz(dbg);

   
   % By q
   massHsgPlus_qV = sum(schoolS.frac_sqcM(cS.iHSG : cS.nSchool, :, iCohort), 1);
   massColl_qV = sum(schoolS.frac_sqcM(cS.iCD : cS.nSchool, :, iCohort), 1);
   massGrad_qV = schoolS.frac_sqcM(cS.iCG, :, iCohort);
   mass_qV = sum(schoolS.frac_sqcM(:,:,iCohort), 1);

   schoolS.fracEnter_qcM(:,iCohort) = massColl_qV(:) ./ massHsgPlus_qV(:);
   % Fraction graduating not conditional on entry
   schoolS.fracGrad_qcM(:,iCohort) = massGrad_qV(:) ./ massHsgPlus_qV(:);
   schoolS.fracHsg_qcM(:,iCohort) = massHsgPlus_qV(:) ./ mass_qV(:);

   
   % By yp
   massHsgPlus_yV = sum(schoolS.frac_sycM(cS.iHSG : cS.nSchool, :, iCohort), 1);
   massColl_yV = sum(schoolS.frac_sycM(cS.iCD : cS.nSchool, :, iCohort), 1);
   massGrad_yV = schoolS.frac_sycM(cS.iCG, :, iCohort);
   mass_yV = sum(schoolS.frac_sycM(:,:,iCohort), 1);

   schoolS.fracEnter_ycM(:,iCohort) = massColl_yV(:) ./ massHsgPlus_yV(:);
   schoolS.fracGrad_ycM(:,iCohort) = massGrad_yV(:) ./ massHsgPlus_yV(:);
   schoolS.fracHsg_ycM(:,iCohort) = massHsgPlus_yV(:) ./ mass_yV(:);

   
   % by [q, y]
   massHsgPlus_qyM = sum(schoolS.frac_sqycM(cS.iHSG : cS.nSchool, :,:, iCohort), 1);
   massColl_qyM = sum(schoolS.frac_sqycM(cS.iCD : cS.nSchool, :,:, iCohort), 1);
   massGrad_qyM = schoolS.frac_sqycM(cS.iCG, :,:, iCohort);
   mass_qyM = sum(schoolS.frac_sqycM(:,:,:,iCohort), 1);

   schoolS.fracEnter_qycM(:,:,iCohort) = massColl_qyM ./ massHsgPlus_qyM;
   schoolS.fracGrad_qycM(:,:,iCohort) = massGrad_qyM ./ massHsgPlus_qyM;
   schoolS.fracHsg_qycM(:,:,iCohort) = massHsgPlus_qyM ./ mass_qyM;
   
   schoolS.massHsgPlus_qycM(:,:,iCohort) = massHsgPlus_qyM;

   validateattributes(schoolS.fracEnter_qycM(:,:, iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'positive', '<', 1})


%    % Fraction with at least HSG
%    fracHsgPlus_qyM = squeeze(sum(schoolS.frac_sqycM(cS.iHSG : cS.nSchool, :, :, iCohort), 1));

%    % Fraction entering college
%    fracColl_qyM = squeeze(sum(schoolS.frac_sqycM(cS.iCD : cS.nSchool, :, :, iCohort), 1));
%    
%    % Entry rates (out of HSG)
%    schoolS.fracEnter_qycM(:,:, iCohort) = fracColl_qyM ./ fracHsgPlus_qyM;

%    % Fractions graduating college (out of HSG)
%    schoolS.fracGrad_qycM(:,:,iCohort) = squeeze(schoolS.frac_sqycM(cS.iCG,:,:,iCohort)) ./ fracHsgPlus_qyM;

%    % Fraction with at least HSG
%    schoolS.fracHsgPlus_qycM(:,:,iCohort) = fracHsgPlus_qyM;

%    % Marginals: entry and grad rates
%    % sum(schoolS.frac_sqycM(cS.iCD : cS.nSchool, 
%    [schoolS.fracEnter_qcM(:,iCohort), schoolS.fracEnter_ycM(:,iCohort)] = ...
%       helper_bc1.marginals(schoolS.fracEnter_qycM(:,:,iCohort), schoolS.fracHsgPlus_qycM(:,:,iCohort), cS.dbg);
% 
%    [schoolS.fracGrad_qcM(:,iCohort), schoolS.fracGrad_ycM(:,iCohort)] = ...
%       helper_bc1.marginals(schoolS.fracGrad_qycM(:,:,iCohort), schoolS.fracHsgPlus_qycM(:,:,iCohort), cS.dbg);
% 
%    for iSchool = 1 : cS.nSchool
%       massM = schoolS.frac_sqycM(iSchool, :,:,iCohort);
%       schoolS.frac_scM(iSchool, iCohort) = sum(massM(:));
%    end
end


