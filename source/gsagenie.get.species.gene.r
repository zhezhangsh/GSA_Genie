gsagenie.get.species.gene <- function(input) {
  spe <- input$step1.species;
  typ <- input$step2a.identifier;
  id1 <- readRDS(paste(GENE_HOME, paste(spe, '_just_id_', typ, '.rds', sep=''), sep='/'));
  id2 <- readRDS(paste(GENESET_HOME, 'summary_ids', paste(spe, '_', typ, '.rds', sep=''), sep='/'));
  c(id1, id2);
}