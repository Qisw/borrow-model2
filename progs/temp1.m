function temp1

structS.value = 0.0;
for i1 = 1 : 200
   structS.(sprintf('x%i', i1)) = 2.0;
end

tic
for i1 = 1 : 1e5
   structS.value = structS.value + 1.5;
end
toc


tS = temp2;
tic
for i1 = 1 : 1e5
   tS.value = tS.value + 1.5;
end
toc



x1 = 0.0;
tic
for i1 = 1 : 1e5
   x1 = x1 + 1.5;
end
toc


end