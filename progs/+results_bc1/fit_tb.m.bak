function fit_tb(setNo, expNo)
% Table with model fit
%{
Only shows targeted moments

Table structure
   Description | model | data
%}

cS = const_bc1(setNo, expNo);
% tgS = var_load_bc1(cS.vCalTargets, cS);
% This contains a vector of devstruct
%  Each element describes a deviation from targets
outS = var_load_bc1(cS.vCalResults, cS);

% For entry also show scalar deviation
% For tweaking model fit
showScalarDev = true;


%% Table structure

% Each row is a devation
nr = 1 + outS.devV.n;
nc = 3;
if showScalarDev
   nc = nc + 1;
end

tbM = cell([nr, nc]);
tbS.rowUnderlineV = zeros([nr,1]);

tbM(1,1:3) = {'Description', 'Model', 'Data'};
if showScalarDev
   tbM{1,4} = 'Dev';
end
tbS.rowUnderlineV(1) = 1;



%% Body

ir = 1;

% Loop over deviations
for i1 = 1 : outS.devV.n
   % Get deviation structure
   devS = outS.devV.dsV{i1};
   ir = ir + 1;
   tbM{ir,1} = devS.longStr;

   modelV = devS.modelV;
   if length(modelV) <= 4  && isvector(modelV)
      % Show directly
      tbM{ir,2} = output_bc1.formatted_vector(modelV, devS.fmtStr, cS);
      tbM{ir,3} = output_bc1.formatted_vector(devS.dataV, devS.fmtStr, cS);
   end
   
   if showScalarDev
      tbM{ir,4} = sprintf('%.2f', devS.scalar_dev);
   end
end


%% Write table

latex_lh.latex_texttb_lh(fullfile(cS.fitDir, 'fit.tex'), tbM, 'Caption', 'Label', tbS);


end
