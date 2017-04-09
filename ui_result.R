####################################################################################################
####################################################################################################
# Result
conditionalPanel(
  condition='input.result_show==true',
  # condition='true',
  
  wellPanel(
    style = 'background-color: #F08080',
    
    div(
      style="display: inline-block;", 
      h2(HTML("<font color='#FFFFFF' face='Tagesschrift'><b>Analysis result</b></font>"))
    ),
    div(style="display: inline-block; width: 40px;", h6()), 
    div(
      style="display: inline-block;",
      conditionalPanel(
        # condition = 'true',
        condition = 'input[["result_split"]] == true',
        div(style="display: inline-block; ", checkboxInput('result.split', 'Split collections', value=FALSE)),
        div(style="display: inline-block; width: 10px;", h6()),
        div(
          style="display: inline-block; width: 240px;", 
          conditionalPanel(
            condition = 'input[["result.split"]] == true',
            selectizeInput('result.collection', NULL, NULL)
          )
        )
      )
    ), br(),
    
    DT::dataTableOutput('result.table', width='100%'),
    div(style="display: inline-block;", downloadButton('result.download1', 'Download table', class='dB')),
    div(style="display: inline-block; width: 10px;", h6()), 
    div(style="display: inline-block;", downloadButton('result.download0', 'Download all', class='dB')), 
    div(style="display: inline-block; width: 5px;", h6()), 
    div(style="display: inline-block; color: #D8D8D8; vertical-align: bottom;", 
        h6(HTML("<b>Download result table, gene sets, inputs, etc. in one .Rdata file.</b>"))), 
    br(), br(),
    
    conditionalPanel(
      # condition = 'true',
      condition = 'input.result_plot == true',
      div(style="display: inline-block; width: 49%;", plotlyOutput('result.plot')),
      div(style="display: inline-block; width: 1%;", h6('')),
      div(
        style="display: inline-block; width: 49%; vertical-align: top;", 
        DT::dataTableOutput('result.geneset'),
        downloadButton('result.download2', 'Download table', class='dB')
      )
    )
  )
)