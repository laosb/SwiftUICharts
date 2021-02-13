//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a multi line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 
 # Example
 ```
 static func weekOfData() -> MultiLineChartData {
  
      let data = MultiLineDataSet(dataSets: [
                                      LineDataSet(dataPoints: [
                                          LineChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
                                          LineChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
                                          LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
                                          LineChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
                                          LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
                                          LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
                                          LineChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
                                      ],
                                      legendTitle: "Test One",
                                      pointStyle: PointStyle(),
                                      style: LineStyle(colour: Color.red)),
                                      LineDataSet(dataPoints: [
                                          LineChartDataPoint(value: 90,  xAxisLabel: "M", pointLabel: "Monday"),
                                          LineChartDataPoint(value: 20,   xAxisLabel: "T", pointLabel: "Tuesday"),
                                          LineChartDataPoint(value: 120, xAxisLabel: "W", pointLabel: "Wednesday"),
                                          LineChartDataPoint(value: 85,  xAxisLabel: "T", pointLabel: "Thursday"),
                                          LineChartDataPoint(value: 140, xAxisLabel: "F", pointLabel: "Friday"),
                                          LineChartDataPoint(value: 10,  xAxisLabel: "S", pointLabel: "Saturday"),
                                          LineChartDataPoint(value: 20,   xAxisLabel: "S", pointLabel: "Sunday")
                                      ],
                                      legendTitle: "Test Two",
                                      pointStyle: PointStyle(),
                                      style: LineStyle(colour: Color.blue))])
      
      let metadata = ChartMetadata(title: "Some Data", subtitle: "A Week")
      let labels = ["Monday", "Thursday", "Sunday"]
      
      return MultiLineChartData(dataSets    : data,
                                metadata    : metadata,
                                xAxisLabels : labels,
                                chartStyle  : LineChartStyle(baseline: .zero),
                                noDataText  : Text("No Data"))
  }
}
 
 ```
 
 ---
 
 # Parts
 
 ## LineDataSet
 ```
 LineDataSet(dataPoints: [LineChartDataPoint],
                         legendTitle: String,
                         pointStyle: PointStyle,
                         style: LineStyle)
 ```
 ### LineChartDataPoint
 ```
 LineChartDataPoint(value: Double,
                    xAxisLabel: String?,
                    pointLabel: String?,
                    date: Date?)
 ```
 
 ### PointStyle
 ```
 PointStyle(pointSize: CGFloat,
            borderColour: Color,
            fillColour: Color,
            lineWidth: CGFloat,
            pointType: PointType,
            pointShape: PointShape)
 ```
 
 ### LineStyle
 ```
 LineStyle(colour: Color,
           ...)
 
 LineStyle(colours: [Color],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(stops: [GradientStop],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(...,
           lineType: LineType,
           strokeStyle: Stroke,
           ignoreZero: Bool)
 ```
 
 ## ChartMetadata
 ```
 ChartMetadata(title: String?, subtitle: String?)
 ```
 
 ## LineChartStyle
 
 ```
 LineChartStyle(infoBoxPlacement        : InfoBoxPlacement,
                infoBoxValueColour      : Color,
                infoBoxDescriptionColor : Color,
                xAxisGridStyle          : GridStyle,
                xAxisLabelPosition      : XAxisLabelPosistion,
                xAxisLabelColour        : Color,
                xAxisLabelsFrom         : LabelsFrom,
                yAxisGridStyle          : GridStyle,
                yAxisLabelPosition      : YAxisLabelPosistion,
                yAxisLabelColour        : Color,
                yAxisNumberOfLabels     : Int,
                baseline                : Baseline,
                globalAnimation         : Animation)
 ```
 
 ### GridStyle
 ```
 GridStyle(numberOfLines: Int,
           lineColour   : Color,
           lineWidth    : CGFloat,
           dash         : [CGFloat],
           dashPhase    : CGFloat)
 ```
 
 ---
 
 # Also See
 - [LineDataSet](x-source-tag://LineDataSet)
    - [LineChartDataPoint](x-source-tag://LineChartDataPoint)
    - [PointStyle](x-source-tag://PointStyle)
        - [PointType](x-source-tag://PointType)
        - [PointShape](x-source-tag://PointShape)
    - [LineStyle](x-source-tag://LineStyle)
        - [ColourType](x-source-tag://ColourType)
        - [LineType](x-source-tag://LineType)
        - [GradientStop](x-source-tag://GradientStop)
 - [ChartMetadata](x-source-tag://ChartMetadata)
 - [LineChartStyle](x-source-tag://LineChartStyle)
    - [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
    - [GridStyle](x-source-tag://GridStyle)
    - [XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
    - [LabelsFrom](x-source-tag://LabelsFrom)
    - [YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)

 # Conforms to
 - ObservableObject
 - Identifiable
 - LineChartDataProtocol
 - LineAndBarChartData
 - ChartData
 
 - Tag: LineChartData
 */
public class MultiLineChartData: LineChartDataProtocol {
    
    // MARK: - Properties
    public let id   : UUID  = UUID()
    
    @Published public var dataSets      : MultiLineDataSet
    @Published public var metadata      : ChartMetadata
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : LineChartStyle
    @Published public var legends       : [LegendData]
    @Published public var viewData      : ChartViewData
    @Published public var isFilled      : Bool = false
    @Published public var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: - Initializers
    /// Initialises a Multi Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : MultiLineDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.line, .multi)
        self.setupLegends()
    }

    // MARK: - Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:
                
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets[0].dataPoints) { data in
                        if let label = data.xAxisLabel {
                            Text(label)
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        if data != self.dataSets.dataSets[0].dataPoints[self.dataSets.dataSets[0].dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
                .padding(.horizontal, -4)
                
                
            case .chartData:
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Text(data)
                                .font(.caption)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            if data != labelArray[labelArray.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                }
            }
        }
    }
    
    // MARK: - Touch
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [LineChartDataPoint] {
        var points : [LineChartDataPoint] = []
        for dataSet in dataSets.dataSets {
            let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[index])
            }
        }
        return points
    }
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {

        var locations : [HashablePoint] = []
        for dataSet in dataSets.dataSets {
            
            let minValue : Double = self.getMinValue()
            let range    : Double = self.getRange()
            
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection : CGFloat = chartSize.size.height / CGFloat(range)
            let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                               y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.size.height))
            }
        }
        return locations
    }
    
    // MARK: - Legends
    public func setupLegends() {
        for dataSet in dataSets.dataSets {
            if dataSet.style.colourType == .colour,
               let colour = dataSet.style.colour
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : colour,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.colourType == .gradientColour,
                      let colours = dataSet.style.colours
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.colourType == .gradientStops,
                      let stops = dataSet.style.stops
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               stops      : stops,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
            }
        }
    }
    
    // MARK: - Data Functions
    public func getRange() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.multiDataSetMaxValue(from: dataSets) - min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.multiDataSetMaxValue(from: dataSets)
        }
    }
    public func getMinValue() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return 0
        }
    }
    
    public typealias Set = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
}
