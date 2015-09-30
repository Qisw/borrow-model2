function plot_line(xV, yV, iLine, cS)
% Add a line to a plot

figS = const_fig_bc1;
idxV = find(~isnan(yV)  &  (yV ~= cS.missVal));
if ~isempty(idxV)
   if length(idxV) > 10
      lStyle = figS.lineStyleDenseV{iLine};
   else
      lStyle = figS.lineStyleV{iLine};
   end
   plot(xV, yV, lStyle, 'color', figS.colorM(iLine,:));
end


end