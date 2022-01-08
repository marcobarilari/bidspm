function status = noRoiFound(varargin)
  %
  % USAGE::
  %
  %   status = noRoiFound(opt, roiList, folder)
  %
  % :param opt: obligatory argument.
  % :type opt: structure
  % :param roiList: obligatory argument.
  % :type roiList: cell
  % :param folder: optional argument. default: ``''``
  % :type folder: path
  %
  % :returns: - :status: (boolean)
  %
  % (C) Copyright 2022 CPP_SPM developers

  p = inputParser;

  default_folder = '';

  addRequired(p, 'opt', @isstruct);
  addOptional(p, 'roiList', @isstruct);
  addParameter(p, 'folder', default_folder, @isdir);

  parse(p, varargin{:});

  status = false;

  if isempty(p.Results.roiList{1})

    status = true;

    tolerant = true;
    msg = sprintf('No ROI found in folder: %s', p.Results.folder);
    id = 'noRoiFile';
    errorHandling(mfilename(), id, msg, tolerant, p.Results.opt.verbosity);

  end

end
