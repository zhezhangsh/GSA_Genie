wellPanel(
  style = 'background-color: #F8F8FF',
  titlePanel(
    windowTitle = "GSA Genie",
    title = h1(HTML("<font size=20><b>&nbsp&nbsp<b>GSA Genie</b></font>"))
  ),
  div(style="display: inline-block;", h2(HTML("<font color='#999999' face='Tagesschrift', size=5>&nbsp&nbsp&nbsp&nbspOnline <u>G</u>ene <u>S</u>et <u>A</u>nalysis</font>"))), 
  div(style="display: inline-block; width: 10px", h5('')),
  div(style="display: inline-block;", h2(HTML("<font color='#999999' face='Tagesschrift', size=5><b>-</b></font>"))),
  div(style="display: inline-block; width: 10px", h5('')),
  div(style="display: inline-block;", h4(HTML("<font color='#999999' face='Tagesschrift'><b>", geneset.ln, '</font></b>', sep=''))),
  div(style="display: inline-block; width: 10px", h5('')),
  
  div(
    style="display: inline-block;",
    conditionalPanel(condition = 'input.detail == false', actionLink('detail.show', 'Show details')),
    conditionalPanel(condition = 'input.detail == true',  actionLink('detail.hide', 'Hide details'))
  ),
  
  conditionalPanel(
    condition = 'input.detail==true',
    DT::dataTableOutput(outputId = 'title.table', width = '100%')
  )
)