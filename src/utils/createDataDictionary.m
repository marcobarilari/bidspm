% (C) Copyright 2019 CPP BIDS SPM-pipeline developpers

function createDataDictionary(subFuncDataDir, fileName, nbColums)

  namecColumns = { ...
                  'trans_x', ...
                  'trans_y', ...
                  'trans_z', ...
                  'rot_x', ...
                  'rot_y', ...
                  'rot_z', ...
                  'trans_x_derivative1', ...
                  'trans_y_derivative1', ...
                  'trans_z_derivative1', ...
                  'rot_x_derivative1', ...
                  'rot_y_derivative1', ...
                  'rot_z_derivative1', ...
                  'trans_x_power2', ...
                  'trans_y_power2', ...
                  'trans_z_power2', ...
                  'rot_x_power2', ...
                  'rot_y_power2', ...
                  'rot_z_power2', ...
                  'trans_x_derivative1_power2', ...
                  'trans_y_derivative1_power2', ...
                  'trans_z_derivative1_power2', ...
                  'rot_x_derivative1_power2', ...
                  'rot_y_derivative1_power2', ...
                  'rot_z_derivative1_power2'};

  for iExtraRegressor = 1:nbColums
    namecColumns{end + 1} = sprintf('censoring_regressor_%i', iExtraRegressor); %#ok<*AGROW>
  end

  dataDictionary = struct( ...
                          'Columns', []);

  for iColumns = 1:numel(namecColumns)
    dataDictionary.Columns{iColumns} = namecColumns{iColumns};
  end

  spm_jsonwrite( ...
                fullfile( ...
                         subFuncDataDir, ...
                         strrep(fileName, ...
                                '_bold.nii',  ...
                                '_desc-confounds_regressors.json')), ...
                dataDictionary, ...
                struct('indent', '   '));
end
