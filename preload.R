.libPaths("/home/zhangz/R/x86_64-pc-linux-gnu-library/3.3");

AWSOMICS_HOME <- "/srv/shiny-server";
APP_HOME <- "/srv/shiny-server/gsagenie";
RCHIVE_HOME <- "/zhangz/rchive";

GENE_HOME <- paste(RCHIVE_HOME, '/data/gene/public/entrez/r', sep=''); # Location of gene annotation data
GENESET_HOME <- paste(RCHIVE_HOME, '/data/gene.set/collection', sep=''); # Location of gene annotation data

require(shinythemes);
require(plotly);

require(RoCA);
require(rchive);
require(awsomics);

fn <- paste(APP_HOME, 'source', dir(paste(APP_HOME, 'source', sep='/')), sep='/');
fnc <- sapply(fn, function(fn) if (gregexpr('\\.R$', fn, ignore.case=TRUE)>0) source(fn));

geneset <- readRDS(paste(GENESET_HOME, 'summary_tree.rds', sep='/'));
geneset.smm <- readRDS(paste(GENESET_HOME, 'summary.rds', sep='/'));
geneset.n1 <- sum(geneset.smm$Num_Geneset);
geneset.n2 <- sum(geneset.smm$Num_Collection);
geneset.n3 <- nrow(geneset.smm);
geneset.ln <- paste(format(geneset.n1, big.mark = ','), 'gene sets in', format(geneset.n2, big.mark = ','),
                    'collections from', geneset.n3, 'sources.'); 

id.type <- list('Entrez Gene ID'='entrez', 'Official Symbol'='symbol', 'Ensembl Gene ID'='ensembl');
id.example <- c('entrez' = 'ex. 7157, 22059', 'symbol' = 'ex. TP53, Trp53', 
                'ensembl' = 'ex. ENSG00000141510, ENSMUSG00000059552')
tip2a <- readLines(paste(APP_HOME, 'source', 'tip_step2a.txt', sep='/'));
tip2b <- readLines(paste(APP_HOME, 'source', 'tip_step2b.txt', sep='/'));
tip3ab <- readLines(paste(APP_HOME, 'source', 'tip_step3ab.txt', sep='/'));
tip3c <- readLines(paste(APP_HOME, 'source', 'tip_step3c.txt', sep='/'));

######################################################################################
# Step 3 options
gsc.skelet <- readRDS(paste(APP_HOME, 'source', 'gsc_skeleton.rds', sep='/'));
gsa.method <- readRDS(paste(APP_HOME, 'source', 'gsa_method.rds', sep='/'));
ora.method <- list("Fisher's exact test"=1, "Chi-square test"=2, "Proportion test"=3);
stat.type  <- list("P-like"=1, "T-like"=2, "F-like"=3, "Other or not sure"=0);
resc.type  <- list("No re-scaling"=0, "Fit normal distribution"=1, "Log transformation"=2, "Gene ranking"=3);


dt.options  <- list(
  autoWidth = FALSE, caseInsensitve = TRUE, regex = TRUE, sScrollX = TRUE, 
  initComplete = DT::JS("function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#888888', 'color': '#FFFFFF'});", 
                        "}"));

dt.options1 <- c(dt.options, pageLength = 10, dom = 'ftipr'); 
dt.options2 <- c(dt.options, pageLength = 100, dom = 't'); 
dt.options3 <- c(dt.options, pageLength = 6, dom = 'ftipr'); 


