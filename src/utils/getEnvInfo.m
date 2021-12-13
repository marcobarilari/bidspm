function [OS, generatedBy] = getEnvInfo(opt)
  %
  % Gets information about the environement and operating system to help generate
  % data descriptors for the derivatives.
  %
  % USAGE::
  %
  %   [OS, generatedBy] = getEnvInfo()
  %
  % :returns: :OS: (structure) (dimension)
  %           :generatedBy: (structure) (dimension)
  %
  % (C) Copyright 2020 CPP_SPM developers

  generatedBy(1).name = 'cpp_spm';
  generatedBy(1).Version =  getVersion();
  generatedBy(1).Description = '';
  generatedBy(1).CodeURL = '';

  runsOn = 'Matlab';
  if isOctave
    runsOn = 'Octave';
  end

  OS.name = computer();
  OS.platform.name = runsOn;
  OS.platform.version = version();

  if opt.dryRun
    return
  end

  [a, b] = spm('ver');
  OS.spmVersion = [a ' - ' b];

  %     if ispc()
  %         cmd = 'set';
  %     else
  %         cmd = 'env';
  %     end
  %     [~, OS.environmentVariables] = system(cmd);

  try
    [keys, vals] = getenvall('system');
    OS.environmentVariables.keys = keys;
    OS.environmentVariables.values = vals;
  catch
    errorHandling;
    errorHandling(mfilename(), 'envUnknown', 'Could not get env info.', true, opt.verbosity);
  end

end

function [keys, vals] = getenvall(method)
  % from
  % https://stackoverflow.com/questions/20004955/list-all-environment-variables-in-matlab
  if nargin < 1
    method = 'system';
  end
  method = validatestring(method, {'java', 'system'});

  switch method
    case 'java'
      map = java.lang.System.getenv();  % returns a Java map
      keys = cell(map.keySet.toArray());
      vals = cell(map.values.toArray());
    case 'system'
      if ispc()
        % cmd = 'set "';  %HACK for hidden variables
        cmd = 'set';
      else
        cmd = 'env';
      end
      [~, out] = system(cmd);
      vars = regexp(strtrim(out), '^(.*)=(.*)$', ...
                    'tokens', 'lineanchors', 'dotexceptnewline');
      vars = vertcat(vars{:});
      keys = vars(:, 1);
      vals = vars(:, 2);
  end

  % Windows environment variables are case-insensitive
  if ispc()
    keys = upper(keys);
  end

  % sort alphabetically
  [keys, ord] = sort(keys);
  vals = vals(ord);
end
