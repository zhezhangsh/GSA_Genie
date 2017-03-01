options(shiny.maxRequestSize=64000000);
options(shiny.sanitize.errors = FALSE);

source('server_step1.R', local=TRUE);
source('server_step2.R', local=TRUE);
source('server_step3.R', local=TRUE);
source('server_result.R', local=TRUE);

shinyServer(function(input, output, session) {
  cat("new visitor: ", session$token, '\n');
  
  observeEvent(input$detail.show, updateCheckboxInput(session, 'detail', value=TRUE));
  observeEvent(input$detail.hide, updateCheckboxInput(session, 'detail', value=FALSE));
  
  step1_status <- reactiveValues(sel1='', sel2='', sel3='', meta=NULL);
  step2_status <- reactiveValues(list=c(), background=c(), top=c(), table=NULL);
  step3_status <- reactiveValues(type=0, subset=c(), background=c(), geneset=NULL, metadata=NULL, method=NULL, stat=NULL, result=NULL);
  result_status <- reactiveValues(geneset=NULL);
  
  step1_status <- server_step1(input, output, session, step1_status);
  step2_status <- server_step2(input, output, session, step1_status, step2_status);
  step3_status <- server_step3(input, output, session, step1_status, step2_status, step3_status);
  result_status <- server_result(input, output, session, step1_status, step2_status, step3_status, result_status);
  
});




