server_step1 <- function(input, output, session, step1_status) {
  #######################################################################################################################
  # Step 1
  #########################################################################################################
  observeEvent(input$step1.button, {
    updateCheckboxInput(session, 'start', value=TRUE);
    updateCheckboxInput(session, 'step1_show', value=TRUE);
    updateCheckboxInput(session, 'detail', value=FALSE);
  }); 
  
  observeEvent(c(input$step1.size, input$step1.size.max), {
    step1_status <- gsagenie.change.geneset(session, input, output, step1_status);
  });
  
  observeEvent(c(input$step1.source, input$step1.collection, input$step1.species), {
    step1_status <- gsagenie.change.geneset(session, input, output, step1_status, FALSE);
  });
  #########################################################################################################
  
  #########################################################################################################
  ## Download gene sets
  output$step1.download1 <- downloadHandler(
    filename = function() {
      paste(paste('metadata', input$step1.source, input$step1.collection, input$step1.species, sep='_'), input$step1.format, sep='');
    },
    content  = function(file) {
      TrackActivity(session, action = 'Download metadata', dir = 'log',
                    data = list(species = input$step1.species, source = input$step1.source, collection = input$step1.collection));
      gsagenie.geneset.download1(input, step1_status, file);
    }
  );
  output$step1.download2 <- downloadHandler(
    filename = function() {
      paste(paste('genesets', input$step1.source, input$step1.collection, input$step1.species, sep='_'), input$step1.format, sep='');
    },
    content  = function(file) {
      TrackActivity(session, action = 'Download gene list', dir = 'log',
                    data = list(species = input$step1.species, source = input$step1.source, collection = input$step1.collection));
      gsagenie.geneset.download2(input, step1_status, file);
    }
  );
  #########################################################################################################
  
  #########################################################################################################  
  # Choose multiple collections
  observeEvent(input$step1.multiple, {
    step1_status$multiple <- NULL;
    updateSelectizeInput(session, 'step1.multi.selected', choices = list(), selected = NULL);
    output$step1.multi.msg <- renderUI({ NULL; })
  }); 
  observeEvent(input$step1.multi.default, {step1_status <- gsagenie.multi.collection(session, input, output, step1_status, choice= 0); });
  observeEvent(input$step1.multi.select,  {step1_status <- gsagenie.multi.collection(session, input, output, step1_status, choice= 1); });
  observeEvent(input$step1.multi.remove,  {step1_status <- gsagenie.multi.collection(session, input, output, step1_status, choice=-1); }); 
  
  step1_status;
}