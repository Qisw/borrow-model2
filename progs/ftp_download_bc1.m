function ftp_download_bc1

setNo = 5;
expNo = 1;
cS = const_bc1(setNo,expNo);
dirS = helper_bc1.directories(false, setNo, expNo);
kureOutDir = fullfile(dirS.modelDir, 'out');

addpath('/Users/lutz/Documents/econ/matlab/ssh2_v2_m1_r6');

hostName = 'killdevil.unc.edu';
userName = 'lhendri';
pw = 'Tiger>2Kira';

% Simple file download
fileListV = {'v001.mat'};
localPath = '/users/lutz/documents/temp/';
remotePath = cS.matDir;
ssh2_conn = scp_simple_get(hostName, userName, pw, fileListV, localPath, remotePath);


% % ftpS = ftp('lhendri@killdevil.unc.edu', 'lhendri', 'Kira<9Tiger');
% 
% % Set up connection
% ssh2_conn = ssh2_config(hostName, userName, pw);
% 
% % Change to 
% commandStr = ['cd ', kureOutDir];
% ssh2_conn = ssh2_command(ssh2_conn, commandStr);
% 
% 
% keyboard;
% 
% ssh2_conn = ssh2_command(ssh2_conn, 'ls');
% 
% command_response = ssh2_command_response(ssh2_conn);
% command_response{1}
% % to get the number of lines returned
% size(command_response,1)
% 
% 
% % Close Advanced Connection: 
% ssh2_conn = ssh2_close(ssh2_conn);
% 


keyboard;

end