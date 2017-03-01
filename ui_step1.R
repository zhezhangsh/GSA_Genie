
####################################################################################################
####################################################################################################
# Step 1

conditionalPanel(
  condition='input.step1_show == true',

  br(),  
  wellPanel(
    
    style = 'background-color: #2098B0;',
    
    h2(HTML("<font color='FFFFFF' face='Tagesschrift'><b>Step 1. Browse and choose gene sets</b></font>")), br(),
    
    div(style="display: inline-block;", h6(HTML("<b>Source:</b>"))),
    div(style="display: inline-block; width: 185px", selectizeInput('step1.source', NULL, choices=names(geneset), selected='BioSystems')),
    div(style="display: inline-block; width: 5px", h6(HTML(""))),
    
    div(style="display: inline-block;", h6(HTML("<b>Collection:</b>"))),
    div(style="display: inline-block; width: 250px", selectizeInput('step1.collection', NULL, NULL)),
    div(style="display: inline-block; width: 5px", h6(HTML(""))),
    
    div(style="display: inline-block;", h6(HTML("<b>Species:</b>"))),
    div(style="display: inline-block; width: 110px", selectizeInput('step1.species', NULL, NULL)),
    div(style="display: inline-block; width: 10px", h6(HTML(""))),
    
    div(style="display: inline-block;", h6(HTML("<b>Size >=</b>"))),
    div(style="display: inline-block; width: 60px", selectizeInput('step1.size', NULL, c(1, 2, 3, 5, 10, 15, 20, 25, 30, 50), selected=5)),
    
    
    h5(HTML("<font color='#D8D8D8' face='Tagesschrift'><b>Highlight rows if want to download or analyze selected gene sets:</b></font>")),
    DT::dataTableOutput('step1.table', width='100%'), br(),
    
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

