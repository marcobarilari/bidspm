function status = checkToolbox(varargin)
  %
  % Checks that a given SPM toolbox is installed.
  % Possible to install it if necessary.
  %
  % USAGE::
  %
  %   status = checkToolbox(toolboxName, 'verbose', false, 'install', false)
  %
  % :param toolboxName: obligatory argument. Any of {'ALI', 'MACS', 'mp2rage'}.
  % :type toolboxName: char
  %
  % :param verbose: parameter
  % :type  verbose: boolean
  %
  % :param install: parameter
  % :type  install: boolean
  %
  % EXAMPLE::
  %
  %   checkToolbox('MACS', 'verbose', true, 'install', true)
  %

  % (C) Copyright 2021 bidspm developers

  args = inputParser;

  defaultVerbose = false;
  defaultInstall = false;

  addRequired(args, 'toolboxName', @ischar);
  addParameter(args, 'verbose', defaultVerbose, @islogical);
  addParameter(args, 'install', defaultInstall, @islogical);

  parse(args, varargin{:});

  toolboxName = args.Results.toolboxName;

  install = args.Results.install;

  verbose = args.Results.verbose;
  opt.verbosity = 0;
  if verbose
    opt.verbosity = 1;
  end

  knownToolboxes = {'ALI', 'MACS', 'mp2rage'};

  if ~ismember(toolboxName, knownToolboxes)
    msg = sprintf('Unknown toolbox: %s.\nKwnon toolboxes:\n%s\n\n', ...
                  toolboxName, ...
                  bids.internal.create_unordered_list(knownToolboxes));
    id = 'unknownToolbox';
    logger('WARNING', msg, 'id', id, 'filename', mfilename(), 'options', opt);
  end

  status = isdir(fullfile(spm('dir'), 'toolbox', toolboxName));
  if status
    return
  end

  switch lower(toolboxName)

    case 'macs'

      if ~status && install

        installMacstoolbox(opt);

        status = checkToolbox(toolboxName);

      end

    case 'mp2rage'

      msg = sprintf('The toolbox %s should be installed from:\n %s\n\n', ...
                    toolboxName, ...
                    'https://github.com/benoitberanger/mp2rage');
      id = 'missingToolbox';
      logger('WARNING', msg, 'id', id, 'filename', mfilename(), 'options', opt);

  end

  if ~status
    msg = sprintf('The toolbox %s could not be found or installed.\n\n', toolboxName);
    id = 'missingToolbox';
    logger('WARNING', msg, 'id', id, 'filename', mfilename(), 'options', opt);
  end

end

function installMacstoolbox(opt)
  SPM_DIR = spm('dir');
  MACS_TOOLBOX_DIR = fullfile(returnRootDir(), 'lib', 'MACS');

  target_dir = fullfile(SPM_DIR, 'toolbox', 'MACS');

  msg = sprintf('installing MACS toolbox in:\n%s.\n\n', target_dir);
  id = 'installingMacsToolbox';
  logger('WARNING', msg, 'id', id, 'filename', mfilename(), 'options', opt);

  if exist(target_dir, 'dir') == 7
    rmdir(target_dir, 's');
  end
  mkdir(target_dir);
  copyfile(MACS_TOOLBOX_DIR, target_dir);
end
