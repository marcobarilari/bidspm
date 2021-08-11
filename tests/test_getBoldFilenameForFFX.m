% (C) Copyright 2020 CPP_SPM developers

function test_suite = test_getBoldFilenameForFFX %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getBoldFilenameForFFXMNI()

  subLabel = '01';
  funcFWHM = 6;
  iSes = 1;
  iRun = 1;

  opt = setOptions('vislocalizer', subLabel);
  opt.space = {'MNI'};

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  boldFileName = getBoldFilenameForFFX(BIDS, opt, subLabel, funcFWHM, iSes, iRun);

  expectedFileName = fullfile(fileparts(mfilename('fullpath')), ...
                              'dummyData', 'derivatives', 'cpp_spm-preproc', 'sub-01', ...
                              'ses-01', 'func', ...
                              ['sub-01_ses-01_task-vislocalizer', ...
                               '_space-IXI549Space_desc-smth6_bold.nii']);

  assertEqual('s6wu', prefix);
  assertEqual(expectedFileName, boldFileName);

end

function test_getBoldFilenameForFFXIndividual()

  subLabel = '01';
  funcFWHM = 6;
  iSes = 1;
  iRun = 1;

  opt = setOptions('vislocalizer', subLabel);
  opt.space = {'individual'};

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  boldFileName = getBoldFilenameForFFX(BIDS, opt, subLabel, funcFWHM, iSes, iRun);

  expectedFileName = fullfile(fileparts(mfilename('fullpath')), ...
                              'dummyData', 'derivatives', 'cpp_spm-preproc', 'sub-01', ...
                              'ses-01', 'func', ...
                              'sub-01_ses-01_task-vislocalizer', ...
                              '_space-individual_desc-smth6_bold.nii');

  assertEqual(expectedFileName, boldFileName);

end
