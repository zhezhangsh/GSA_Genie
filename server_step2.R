server_step2 <- function(input, output, session, step1_status, step2_status) { 
  #######################################################################################################################
  #######################################################################################################################
  ## Step 2
  observeEvent(input$step2.button, {
    updateCheckboxInput(session, 'step1_show', value=FALSE);
    updateCheckboxInput(session, 'step2_show', value=TRUE);
  });
  
  observeEvent(input$step2a.demo, {
    if (input$step2a.paste == '1') ids <- readRDS(paste(APP_HOME, 'source', 'top_id.rds', sep='/')) else
      ids <- readRDS(paste(APP_HOME, 'source', 'all_id.rds', sep='/'));
    updateTextAreaInput(session, 'step2a.text', value=paste(ids, collapse='\n'));
  });
  
  observeEvent(c(input$step2a.identifier, input$step2b.identifier), {
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='clear_all');
  });
  
  output$step2a.example <- renderText(
    HTML("<font color='#D8D8D8' size=2>", id.example[input$step2a.identifier], "</font>")
  );
  
  output$step2b.ui <- renderUI(fileInput('step2b.file', NULL));
  
  output$step2b.example <- downloadHandler(
    filename = function() {'statistics_example.txt'},
    content  = function(file) {file.copy(paste(APP_HOME, 'source', 'stat.txt', sep='/'), file)}
  );

  observeEvent(input$step2a.button, {
    ids <- gsub(' ', '', strsplit(input$step2a.text, '[\n\t,; ]')[[1]]);
    id0 <- gsagenie.get.species.gene(input);
    ids <- ids[ids %in% id0];
    typ <- names(id.type)[id.type==input$step2a.identifier];
    if (length(ids) == 0) {
      msg <- paste('None of the uploaded gene IDs are recognized (identifier type = ', typ, '; species = ', input$step1.species, ').', sep='');
      msg <- paste('<font color="tomato" size=2>', msg, '</font>', sep='');
    } else if (length(ids) == 1) {
      msg <- paste('Only one of the uploaded gene IDs is recognized (identifier type = ', typ, '; species = ', input$step1.species, '); require at least 2.', sep='');
      msg <- paste('<font color="tomato" size=2>', msg, '</font>', sep='');
    } else {
      pst <- input$step2a.paste;
      lst <- step2_status$list;
      bgd <- step2_status$background;
      if (pst == '1') {
        msg <- paste(length(ids), ' genes are uploaded as gene list.', sep='');
        step2_status$list <- ids;
        if (length(bgd)==0) msg <- paste(msg, 'No background has been uploaded.') else {
          msg <- paste(msg, length(bgd), 'genes have been uploaded as background.');
          msg <- paste(msg, length(intersect(ids, lst)), 'genes are in both.');
        };
      } else {
        msg <- paste(length(ids), ' genes are uploaded as background.', sep='');
        step2_status$background <- ids;
        if (length(lst)==0) msg <- paste(msg, 'No gene list has been uploaded.') else {
          msg <- paste(msg, length(lst), 'genes have been uploaded as gene list.');
          msg <- paste(msg, length(intersect(ids, lst)), 'genes are in both.');
        };
        
      };
      msg <- paste('<font color="#20B098" size=2>', msg, '</font>', sep='');
    };
    
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='step2a_button');
    output$step2a.msg <- renderText(paste('<SPAN style="margin: 8px">', msg, '</SPAN>', sep=''));
  }); 
  
  observeEvent(input$step2b.file, {
    msg <- NULL;
    step2_status$table <- NULL;
    
    fn0 <- input$step2b.file;
    if (is.null(fn0)) {
      msg <- paste('<font color="tomato" size=2>Fail to load file, check file format and extension.</font>', sep='');
    } else {
      dir <- paste(APP_HOME, 'log', Sys.Date(), session$token, sep='/');
      if (!dir.exists(dir)) dir.create(dir, recursive = TRUE);
      fn1 <- paste(dir, fn0$name, sep='/');
      file.copy(fn0$datapath, fn1); 
      
      tbl <- tryCatch(ImportTable(fn1), error = function(e) NULL, warning = function(w) NULL);
      
      if (is.null(tbl)) {
        msg <- paste('<font color="tomato" size=2>Fail to load file, check file format and extension.</font>', sep='');
      } else {
        nms <- colnames(tbl);
        nms <- nms[sapply(nms, function(i) is.numeric(tbl[, i]))];
        if (length(nms) < 1) {
          msg <- paste('<font color="tomato" size=2>None of the columns of loaded table are numeric. Read instruction above to prepare the table properly.</font>', sep='');
        } else {
          ids <- rownames(tbl);
          id0 <- gsagenie.get.species.gene(input);
          tbl <- tbl[ids %in% id0, , drop=FALSE];
          uni <- length(unique(rownames(tbl))); 
          if (uni < 2) {
            msg <- paste('<font color="tomato" size=2>Not enough gene IDs are recognized (identifier type = ', 
                         names(id.type)[id.type==input$step2a.identifier], '; species = ', input$step1.species, 
                         '); require at least 2.</font>', sep='');
          } else { 
            step2_status$table <- tbl; 
            updateSelectInput(session, 'step2b.column', choices = nms);
            msg <- paste("Table loaded:", nrow(tbl), 'total rows,', uni, 'unique recognized gene IDs');
            if (length(nms) == 1)  msg <- paste(msg, 'and 1 column of test statistic.') else
              msg <- paste(msg, 'and', length(nms), 'columns of test statistics.')
            msg <- paste('<font color="#20B098" size=2>', msg, '</font>', sep='');
          };
        };
      };
    };

    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='step2b_file');
    output$step2b.msg <- renderText(paste('<SPAN style="margin: 8px;">', msg, '</SPAN>', sep=''));
  });
  
  observeEvent(input$step2b.column, {
    updateCheckboxInput(session, 'step2b.filter', value = FALSE);
    updateSliderInput(session, 'step2b.chooser', value=c(0, 1), min=0, max=1, step=0.01);
    step2_status$top <- c();
  });
  
  observeEvent(input$step2b.filter, { 
    if (input$step2b.filter) {
      cnm <- input$step2b.column;
      tbl <- step2_status$table;
      if (!is.null(cnm) & cnm!='' & !is.null(tbl) & cnm %in% colnames(tbl)) {
        d <- tbl[, cnm];
        d <- d[!is.na(d)]; 
        
        l <- ceiling(log10(max(d)));
        s <- 10^(l-2); 
        e <- d*10^(2-l); 
        mn <- floor(min(e))/10^(2-l);
        mx <- ceiling(max(e))/10^(2-l); 
        n <- (mx-mn)/s;
        if (n < 20) s <- s/2 else if (n > 100) s <- 2*s;
        updateSliderInput(session, 'step2b.chooser', value=c(mn, mx), min=mn, max=mx, step=s);
        # msg <- paste('<font color="#20B098" size=2>Filtering genes by ', cnm, '</font>', sep='');
      }
    } else {
      updateSliderInput(session, 'step2b.chooser', value=c(0, 1), min=0, max=1, step=0.01);
      # msg <- paste('<font color="#20B098" size=2>Filtering turned off</font>', sep='');
    }; 
    step2_status$top <- c();
    # output$step2b.msg <- renderText(paste('<SPAN style="margin: 8px;">', msg, '</SPAN>', sep=''));
  });
  
  observeEvent(c(input$step2b.chooser, input$step2b.direction, input$step2b.cutoff), { 
    tbl <- step2_status$table;
    sel <- input$step2b.filter;
    if (!is.null(tbl) & sel) {
      msg <- paste('<font color="#20B098" size=2>', nrow(tbl), 'total rows in table.</font>');
      cnm <- input$step2b.column; 
      if (cnm!='' & !is.null(cnm)) {
        step2_status$top <- c(); 
        step2_status$list <- c();
        step2_status$background <- c();

        chs <- input$step2b.chooser;
        drc <- input$step2b.direction;
        cff <- input$step2b.cutoff;
        
        b <- tbl;
        b <- b[!is.na(b[, cnm]), , drop=FALSE]; 
        b <- b[b[, cnm]>=chs[1], , drop=FALSE];
        b <- b[b[, cnm]<=chs[2], , drop=FALSE];
        options(warn=-1); c <- as.numeric(cff); options(warn=1);
        if (!is.na(c)) if (drc == '1') b <- b[b[, cnm]>=c, , drop=FALSE] else  b <- b[b[, cnm]<=c, , drop=FALSE]
        
        id <- unique(rownames(b));
        if (length(id) < 2) {
          step2_status$top <- c();
          msg <- '<font color="#20B098" size=2>Too few genes select; require at least 2. Adjust cutoff to get more.</font>';
        } else {
          step2_status$top <- id;
          msg <- paste('<font color="#20B098" size=2>', length(id), 'rows and', length(unique(id)), 
                       'unique genes are selected from', nrow(tbl), 'total rows.</font>');
        }
      }
      output$step2a.msg <- renderText(NULL);
      output$step2b.msg <- renderText(paste('<SPAN style="margin: 8px;">', msg, '</SPAN>', sep=''));
    }
  });
  
  step2_status;
}