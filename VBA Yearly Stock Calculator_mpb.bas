Attribute VB_Name = "Module1"
Sub stocks2()
    For Each ws In Worksheets
        Dim WorksheetName As String ' define worksheet name
        WorksheetName = ws.Name  ' Grabbed the WorksheetName
        
        ' clear the output columns (just to make it easier new additions:
        Worksheets(WorksheetName).Columns(10).ClearContents
        Worksheets(WorksheetName).Columns(11).ClearContents
        Worksheets(WorksheetName).Columns(12).ClearContents
        Worksheets(WorksheetName).Columns(13).ClearContents
        Worksheets(WorksheetName).Columns(11).ClearFormats
        Worksheets(WorksheetName).Columns(14).ClearContents
        Worksheets(WorksheetName).Columns(15).ClearContents
        Worksheets(WorksheetName).Columns(17).ClearContents
        Worksheets(WorksheetName).Columns(18).ClearContents
        Worksheets(WorksheetName).Columns(19).ClearContents
        
        Worksheets(WorksheetName).Cells(1, 10) = "Ticker"
        ' Worksheets(WorksheetName).Cells(1, 11) = "Opening Price"  ' included this while I was working through the assignment
        ' Worksheets(WorksheetName).Cells(1, 12) = "Closing Price"  ' included this while I was working through the assignment
        Worksheets(WorksheetName).Cells(1, 11) = "Yearly Change"
        Worksheets(WorksheetName).Cells(1, 12) = "Percent Change"
        Worksheets(WorksheetName).Cells(1, 13) = "Total Volume"
        
        Worksheets(WorksheetName).Cells(1, 17) = "Ticker"
        Worksheets(WorksheetName).Cells(1, 18) = "Value"
        
        Worksheets(WorksheetName).Cells(2, 16) = "Greatest % Increase"
        Worksheets(WorksheetName).Cells(3, 16) = "Greatest % Decrease"
        Worksheets(WorksheetName).Cells(4, 16) = "Greatest Total Volume"
        
        LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row    ' Determine the Last Row
        dateCounter = 1 ' a switch to get just the first instance of opening price
        tickerCounter = 2
        totalVolume = 0
        
        For iRow = 2 To LastRow
            ticker1 = Worksheets(WorksheetName).Cells(iRow, 1).Value ' ticker name 1
            ticker2 = Worksheets(WorksheetName).Cells(iRow + 1, 1).Value ' next ticker name
            
            If ticker1 = ticker2 And dateCounter = 1 Then
                openPrice = Worksheets(WorksheetName).Cells(iRow, 3).Value
                dateCounter = dateCounter + 1
                
            ElseIf ticker1 = ticker2 Then
                totalVolume = totalVolume + Worksheets(WorksheetName).Cells(iRow, 7).Value
                
            ElseIf ticker1 <> ticker2 Then
                closePrice = Worksheets(WorksheetName).Cells(iRow, 6).Value
                Worksheets(WorksheetName).Cells(tickerCounter, 10) = ticker1
                
                ' Worksheets(WorksheetName).Cells(tickerCounter, 11) = openPrice    ' included this while I was working through the assignment
                ' Worksheets(WorksheetName).Cells(tickerCounter, 12) = closePrice   ' included this while I was working through the assignment
                
                yearlyChange = closePrice - openPrice ' calculate yearly change
                
                ' tickers with 0 opening prices crashed b/c dividing by zero. Therefore:
                If openPrice = 0 Then
                    percentChange = 0
                Else
                    percentChange = (closePrice / openPrice) - 1
                End If
                
                ' populate cells
                Worksheets(WorksheetName).Cells(tickerCounter, 11) = yearlyChange   ' populate yearly changes
                Worksheets(WorksheetName).Cells(tickerCounter, 12) = percentChange  ' populate % changes
                Worksheets(WorksheetName).Cells(tickerCounter, 12).NumberFormat = "0.00%"   ' change number format to percent

                totalVolume = totalVolume + Worksheets(WorksheetName).Cells(iRow, 7).Value  ' gather volumes
                Worksheets(WorksheetName).Cells(tickerCounter, 13) = totalVolume    ' populate volume
                Worksheets(WorksheetName).Cells(tickerCounter, 13).NumberFormat = "#,##0"   ' change number format to include commas
                
                ' color code according to gains (green) and losses (red)
                If yearlyChange < 0 Then
                    Worksheets(WorksheetName).Cells(tickerCounter, 11).Interior.ColorIndex = 3
                Else
                    Worksheets(WorksheetName).Cells(tickerCounter, 11).Interior.ColorIndex = 4
                End If
                  
                ' update counters
                dateCounter = 1
                tickerCounter = tickerCounter + 1
                totalVolume = 0
                
            End If
    
        Next iRow
               
        ' calculate the biggest winner and find ticker. Then populate cell:
        Worksheets(WorksheetName).Range("R2") = Application.WorksheetFunction.Max(Worksheets(WorksheetName).Range("L:L"))
        maxVal = Application.WorksheetFunction.Max(Worksheets(WorksheetName).Range("L:L"))
        Dim foundRng As Range
        Set foundRng = Worksheets(WorksheetName).Range("L:L").Find(maxVal * 100)
        theMaxAddress = foundRng.Address
        theMaxRow = Split(theMaxAddress, "$")(2)
        theMaxTicker = Worksheets(WorksheetName).Cells(theMaxRow, 10)
        Worksheets(WorksheetName).Range("Q2") = theMaxTicker
        
        ' calculate the biggest loser and find ticker. Then populate cell:
        Worksheets(WorksheetName).Range("R3") = Application.WorksheetFunction.Min(Worksheets(WorksheetName).Range("L:L"))
        minVal = Application.WorksheetFunction.Min(Worksheets(WorksheetName).Range("L:L"))
        Dim foundRng2 As Range
        Set foundRng2 = Worksheets(WorksheetName).Range("L:L").Find(minVal * 100)
        theMinAddress = foundRng2.Address
        theMinRow = Split(theMinAddress, "$")(2)
        theMinTicker = Worksheets(WorksheetName).Cells(theMinRow, 10)
        Worksheets(WorksheetName).Range("Q3") = theMinTicker
        
        ' calculate the biggest volume and find ticker. Then populate cell:
        Worksheets(WorksheetName).Range("R4") = Application.WorksheetFunction.Max(Worksheets(WorksheetName).Range("M:M"))
        maxVOL = Application.WorksheetFunction.Max(Worksheets(WorksheetName).Range("M:M"))
        Dim foundRng3 As Range
        Set foundRng3 = Worksheets(WorksheetName).Range("M:M").Find(maxVOL)
        theVOLAddress = foundRng3.Address
        theVOLrow = Split(theVOLAddress, "$")(2)
        theVOLTicker = Worksheets(WorksheetName).Cells(theVOLrow, 10)
        Worksheets(WorksheetName).Range("Q4") = theVOLTicker
        
        'Change number formats:
        Worksheets(WorksheetName).Range("R2").NumberFormat = "0.00%"
        Worksheets(WorksheetName).Range("R3").NumberFormat = "0.00%"
        Worksheets(WorksheetName).Range("R4").NumberFormat = "#,##0"
             
    Next ws
End Sub


