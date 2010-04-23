function name = sparse_coding_dir()

fullpath = mfilename('fullpath');
name = fullpath(1:end-length(mfilename()));
