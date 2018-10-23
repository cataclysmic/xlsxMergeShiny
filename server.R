# Author: Felix Albrecht
#
# --- necessary libraries
  #require(stringr)
  #require(tabulizer)  # JAVA backend
  require(XLConnect)  # JAVA backend
# --- end -----------------

# --- server function
shinyServer <- function(input, output) {

# --- load workbooks
  wbOne <- eventReactive(input$importLeft, {
    filePath <- input$fileOne$datapath
    wbInOne <- loadWorkbook(filePath,create = FALSE)
    return(wbInOne)
  })

  wbTwo <- eventReactive(input$importRight, {
    filePath <- input$fileTwo$datapath
    wbIn <- loadWorkbook(filePath,create = FALSE)
    return(wbIn)
  })


# --- making workbook available
  dfOne <- reactive({
    df <- wbOne()
    if(is.null(df))return(NULL)
    return(df)
  })

  dfTwo <- reactive({
    df <- wbTwo()
    if(is.null(df))return(NULL)
    return(df)
  })

# --- page selector
  output$pagesOne <- renderUI({
    if(!is.null(input$fileOne)){
      selectInput("pagesLeft", "Wähle den Spreadsheet", getSheets(dfOne()))
      }
    else{NULL}
  })

  output$pagesTwo <- renderUI({
    if(!is.null(input$fileTwo)){
      selectInput("pagesRight", "Wähle den Spreadsheet", getSheets(dfTwo()))
      }
    else{NULL}
  })

# --- column selector
  output$columnsOne <- renderUI({
    if(!is.null(input$pagesLeft)){
      select2Input("joinLeft","Wählen Sie die Fusionsspalten",
                  names(readWorksheet(dfOne(),input$pagesLeft)))
      }
    else{NULL}
  })

  output$columnsTwo <- renderUI({
    if(!is.null(input$pagesLeft)){
      select2Input("joinRight","Wählen Sie die Fusionsspalten",
                 names(readWorksheet(dfTwo(),input$pagesRight)))
      }
    else{NULL}
  })

  makeTable <- eventReactive(input$fuse,{
    print(input$joinLeft)
    print(input$joinRight)
    x <- readWorksheet(dfOne(),input$pagesLeft)
    y <- readWorksheet(dfTwo(),input$pagesRight)
    joint <- merge(x=x, y=y,
                   by.x=input$joinLeft,
                   by.y=input$joinRight)

    hide('infobox')
    return(joint)
  })

  output$mergeTab <- renderDataTable({makeTable()})

# --- xlsx download
  xlsxName <- reactive({
      fname <- paste("Zusammengefuehrt",input$fileOne$name,".xlsx",sep="")
      return(fname)
  })

# --- download pipe
  output$downloadData <- downloadHandler(
    filename = xlsxName(),
    content = function(file = paste(input$fileOne$datapath,xlsxName(),sep="")
                       ) {

## -- create xlsx workbook
      newFile <- loadWorkbook(file,create=TRUE)
      createSheet(newFile,name="Seite 1")
      writeTbl <- makeTable()
      writeWorksheet(newFile,data=writeTbl,sheet="Seite 1",header=TRUE)

## -- write workbook
      saveWorkbook(newFile)
    })



}

