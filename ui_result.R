####################################################################################################
####################################################################################################
# Result
conditionalPanel(
  condition='input.result_show==true',
  # condition='true',
  
  wellPanel(
    style = 'background-color: #707070',
    
    h2(HTML("<font color='#FFFFFF' face='Tagesschrift'><b>Analysis result</b></font>")),
    
    DT::dataTableOutput('result.table', width='100%'),
    downloadButton('result.download1', 'Download table', class='dB'), br(), br(),
    
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