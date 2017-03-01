gsagenie.get.geneset<-function(pth, src, col, spe) { 
  fn <- paste(pth, src, col, spe, 'metadata.rds', sep='/');
  if (file.exists(fn)) readRDS(fn) else NULL;
}; 

gsagenie.get.mapping<-function(pth, src, col, spe, idf) { 
  fn <- paste(pth, src, col, spe, paste(idf, '.rds', sep=''), sep='/');
  if (file.exists(fn)) readRDS(fn) else NULL;
}; 