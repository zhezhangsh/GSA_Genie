
####################################################################################################
####################################################################################################
# Step 1

conditionalPanel(
  condition='input.step1_show == true',

  br(),  
  wellPanel(
    style = 'background-color: #2098B0;',
    
    h2(HTML("<font color='FFFFFF' face='Tagesschrift'><b>Step 1. Browse and choose gene sets</b></font>")), br(),
    
    div(
      style = 'display: inline-block; width: 50%; vertical-align: top;',
      div(style="display: inline-block; width: 12%; text-align: right;", h6(HTML("<b>Species:</b>"))),
      div(style="display: inline-block; width: 1%;", h6(HTML(""))),
      div(style="display: inline-block; width: 26%;", selectizeInput('step1.species', NULL, names(geneset.mp))),
      # div(style="display: inline-block; width: 1%; height: 32px;", h6(HTML(""))),
      
      div(style="display: inline-block; width: 16%; text-align: right;", h6(HTML("<b>Size:</b>"))),
      div(style="display: inline-block; width: 1%;", h6(HTML(""))),
      div(style="display: inline-block; width: 15%;", selectizeInput('step1.size', NULL, c(1, 2, 3, 5, 10, 15, 20, 25, 30, 50), selected=5)),
      div(style="display: inline-block; width: 1%;", h6(HTML(""))),
      div(style="display: inline-block; width: 2%;", h6(HTML("to"))),
      div(style="display: inline-block; width: 1%;", h6(HTML(""))),
      div(style="display: inline-block; width: 18%;", selectizeInput('step1.size.max', NULL, c(100, 200, 500, 1000, 2000, 5000), selected=500)),
      br(),

      div(style="display: inline-block; width: 12%; text-align: right; height: 32px;", h6(HTML("<b>Source:</b>"))),
      div(style="display: inline-block; width: 1%; height: 32px;", h6(HTML(""))),
      div(style="display: inline-block; width: 26%; height: 32px;", selectizeInput('step1.source', NULL, choices=names(geneset.mp[[1]]))),
      # div(style="display: inline-block; width: 1%", h6(HTML(""))),
      
      div(style="display: inline-block; width: 16%; text-align: right; height: 32px;", h6(HTML("<b>Collection:</b>"))),
      div(style="display: inline-block; width: 1%; height: 32px;", h6(HTML(""))),
      div(style="display: inline-block; width: 40%; height: 32px;", selectizeInput('step1.collection', NULL, choices=names(geneset.mp[[1]][[1]]))),
      br(),
      
      ##############################################################################################################
      ## select multiple collections
      div(style="display: inline-block; width: 2%; height: 32px;", h5(HTML(""))),
      div(style="display: inline-block; height: 32px;", checkboxInput('step1.multiple', 'Choose multiple collections', value=FALSE)),
      div(style="display: inline-block; width: 4%; height: 32px;", h5(HTML(""))),
      div(style="display: inline-block; height: 32px;", htmlOutput('step1.multi.msg')), br(),
      
      conditionalPanel(
        condition = 'input[["step1.multiple"]] == true',
        div(style="display: inline-block; width: 1%; height: 32px;", h5(HTML(""))),
        div(style="display: inline-block; height: 32px;", actionButton('step1.multi.default', 'Add defaults', icon = icon('plus-square'), class='dB')),
        div(style="display: inline-block; width: 5px; height: 32px;", h5(HTML(""))),
        div(style="display: inline-block; height: 32px;", actionButton('step1.multi.select', 'Add selected', icon = icon('plus'), class='dB')),
        div(style="display: inline-block; width: 20px; height: 32px;", h5(HTML(""))),
        div(style="display: inline-block; height: 32px;", actionButton('step1.multi.remove', 'Remove', icon = icon('trash'), class='dB')), br(), br(),
        div(style="display: inline-block; width: 1%; height: 32px;", h5(HTML(""))),
        div(style="display: inline-block; width: 96%; height: 32px;", selectizeInput('step1.multi.selected', NULL, NULL))
      )
    ), 
    div(style="display: inline-block; width: 1%", h6(HTML(""))),
    div(
      style = 'display: inline-block; width: 48%; vertical-align: top;',
      wellPanel(
        style = "background-color: #FFFFFF;", 
        h4(HTML('<font color="#2098B0"><b>', 'Tips:', '</b></font>')),
        div(
          style="display: inline-block; width: 95%",
          h6(HTML('<font color="#2098B0"><p style="line-height:150%">', paste(tip1, collapse='<br>'), '</p></font>'))
        )            
      )
    ), br(),


    # h5(HTML("<font color='#D8D8D8' face='Tagesschrift'><b>Highlight rows if want to download or analyze selected gene sets:</b></font>")),
    DT::dataTableOutput('step1.table', width='100%'),
    
    div(style="display: inline-block;", downloadButton('step1.download1', 'Download table', class='dB')),
    div(style="display: inline-block; width: 10px;", h5(HTML(""))),
    div(style="display: inline-block;", downloadButton('step1.download2', 'Download gene list', class='dB')),
    div(style="display: inline-block; width: 10px;", h5(HTML(""))),
    div(style="display: inline-block;", h4(HTML("<font face='Tagesschrift'>Choose format:</font>"))),
    div(style="display: inline-block; width: 5px;", h5(HTML(""))),
    div(style="display: inline-block; width: 85px;", selectizeInput('step1.format', NULL, c('.txt', '.rds', '.rdata'))),
    div(style="display: inline-block; width: 5px;", h5(HTML(""))),
    div(style="display: inline-block;", h4(HTML("<font face='Tagesschrift'>Choose identifier:</font>"))),
    div(style="display: inline-block; width: 5px;", h5(HTML(""))),
    div(style="display: inline-block; width: 165px;", selectizeInput('step1.identifier', NULL, id.type))
  )  
)

