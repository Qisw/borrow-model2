function open_bc1(findStr)
% Quickly open a program file. Just enter part of the name

dirS = helper_bc1.directories(true, 1,1);

files_lh.open_files_by_name(dirS.progDir, findStr)

end