function cal_dev_test
% Only syntax testing required

rng(40);
cS = rfm1_bc1.Const;
paramS = rfm1_bc1.CalParams;
paramS.initialize_random;

c0S = const_bc1(cS.setNo, cS.expNo);
tgS = var_load_bc1(c0S.vCalTargets, c0S);


rfm1_bc1.cal_dev(paramS, tgS, cS)


end