function test_suite = test_convertOnsetTsvToMat %#ok<*STOUT>
  %
  % (C) Copyright 2022 CPP_SPM developers

  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end

  initTestSuite;

end

function test_convertOnsetTsvToMat_warning_missing_variable_to_convolve

  if isOctave
    return
  end

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');
  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(),  'models', ...
                            'model-vismotionWithExtraVariable_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);

  opt.verbosity = 1;

  % WHEN
  assertWarning(@() convertOnsetTsvToMat(opt, tsvFile), ...
                'convertOnsetTsvToMat:variableNotFound');

end

function test_convertOnsetTsvToMat_transformers_with_dummy_regressors

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');
  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(),  'models', ...
                            'model-vismotionWithExtraVariable_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);

  opt.glm.useDummyRegressor = true;

  % WHEN
  fullpathOnsetFilename = convertOnsetTsvToMat(opt, tsvFile);

  % THEN
  load(fullpathOnsetFilename);

  assertEqual(names, {'VisMot', 'VisStat', 'dummyRegressor'});

  cleanUp(fullpathOnsetFilename);

end

function test_convertOnsetTsvToMat_basic()

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');
  opt = setOptions('vismotion');
  opt.model.bm = BidsModel('file', opt.model.file);

  % WHEN
  fullpathOnsetFilename = convertOnsetTsvToMat(opt, tsvFile);

  % THEN
  assertEqual(fullfile(getDummyDataDir(), ...
                       'tsv_files', ...
                       'sub-01_task-vismotion_onsets.mat'), ...
              fullpathOnsetFilename);
  assertEqual(exist(fullpathOnsetFilename, 'file'), 2);

  load(fullpathOnsetFilename);

  assertEqual(names, {'VisMot', 'VisStat'});
  assertEqual(onsets, {2, 4});
  assertEqual(durations, {2, 2});

  cleanUp(fullpathOnsetFilename);

end

function test_convertOnsetTsvToMat_input_from_non_trial_type_column

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), 'tsv_files', 'sub-01_task-FaceRepetitionBefore_events.tsv');
  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(),  'models', ...
                            'model-faceRepetitionNoTrialType_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);

  % WHEN
  fullpathOnsetFilename = convertOnsetTsvToMat(opt, tsvFile);

  % THEN
  load(fullpathOnsetFilename);

  assertEqual(names, {'famous', 'unfamiliar'});
  assertEqual(numel(onsets{1}), 52);
  assertEqual(durations, {zeros(1, 52), zeros(1, 52)});

  cleanUp(fullpathOnsetFilename);

end

function test_convertOnsetTsvToMat_no_condition_in_design_matrix

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');

  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(),  'models', ...
                            'model-vismotionNoCondition_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);

  opt.verbosity = 1;

  % WHEN
  fullpathOnsetFilename =  convertOnsetTsvToMat(opt, tsvFile);

  load(fullpathOnsetFilename);

  assertEqual(names, {});
  assertEqual(onsets, {});
  assertEqual(durations, {});

end

function test_convertOnsetTsvToMat_dummy_regressor()

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');
  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(), 'models', 'model-vismotionMVPA_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);
  opt.glm.useDummyRegressor = true;

  % WHEN
  fullpathOnsetFilename = convertOnsetTsvToMat(opt, tsvFile);

  % THEN
  assertEqual(fullfile(getDummyDataDir(), ...
                       'tsv_files', ...
                       'sub-01_task-vismotion_onsets.mat'), ...
              fullpathOnsetFilename);
  assertEqual(exist(fullpathOnsetFilename, 'file'), 2);

  load(fullpathOnsetFilename);

  assertEqual(names, {'dummyRegressor'});
  assertEqual(onsets, {nan});
  assertEqual(durations, {nan});

  cleanUp(fullpathOnsetFilename);

end

function test_convertOnsetTsvToMat_missing_trial_type()

  if isOctave
    return
  end

  % GIVEN
  tsvFile = fullfile(getDummyDataDir(), ...
                     'tsv_files', ...
                     'sub-01_task-vismotion_events.tsv');
  opt = setOptions('vismotion');
  opt.model.file = fullfile(getDummyDataDir(), 'models', 'model-vismotionMVPA_smdl.json');
  opt.model.bm = BidsModel('file', opt.model.file);
  opt.verbosity = 1;

  assertWarning(@() convertOnsetTsvToMat(opt, tsvFile), ...
                'convertOnsetTsvToMat:trialTypeNotFound');

end

function opt = setUp(opt)
  opt.model.bm = BidsModel('file', opt.model.file);
end

function cleanUp(inputFile)
  delete(inputFile);
end
