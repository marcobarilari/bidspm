function matlabbatch = setBatchSmoothing(matlabbatch, opt, images, fwhm, prefix)
  %
  % Small wrapper to create smoothing batch
  %
  % USAGE::
  %
  %   matlabbatch = setBatchSmoothing(matlabbatch, images, fwhm, prefix)
  %
  % :param matlabbatch:
  % :type matlabbatch: structure
  % :param images:
  % :type images:
  % :param fwhm:
  % :type fwhm:
  % :param prefix:
  % :type prefix:
  %
  % :returns: - :matlabbatch: (structure)
  %
  %
  % (C) Copyright 2019 CPP_SPM developers

  printBatchName('smoothing images', opt);

  matlabbatch{end + 1}.spm.spatial.smooth.data = images;
  matlabbatch{end}.spm.spatial.smooth.prefix = prefix;
  matlabbatch{end}.spm.spatial.smooth.fwhm = [fwhm fwhm fwhm];

  matlabbatch{end}.spm.spatial.smooth.dtype = 0;
  matlabbatch{end}.spm.spatial.smooth.im = 0;

end
