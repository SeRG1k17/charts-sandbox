//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Charts

//class MyViewController : UIViewController {
//    override func loadView() {
//        let view = UIView()
//        view.backgroundColor = .white
//
//        let label = UILabel()
//        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
//        label.text = "Hello World!"
//        label.textColor = .black
//
//        view.addSubview(label)
//        self.view = view
//    }
//}


private let ITEM_COUNT = 12

class ViewController: UIViewController {
    
    @IBOutlet var chartView: CombinedChartView! = CombinedChartView()
    
    var shouldHideData: Bool = false
    let months = ["12 PM", "1 PM", "2 PM",
                  "3 PM", "4 PM", "5 PM",
                  "6 PM", "7 PM", "8 PM",
                  "9 PM", "10 PM", "11 PM"]
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white

        chartView.frame = CGRect(x: 16, y: 100, width: 350, height: 400)
        view.addSubview(chartView)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Combined Chart"
        
        setupGraph()
        updateChartData()
        print(view.frame)
    }
    
    func setupGraph() {
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        chartView.drawOrder = [DrawOrder.bar.rawValue,
                               DrawOrder.bubble.rawValue,
                               DrawOrder.candle.rawValue,
                               DrawOrder.line.rawValue,
                               DrawOrder.scatter.rawValue]
        
        chartView.legend.enabled = false
        
        chartView.backgroundColor = .yellow
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = .red
        
        //        let myLayer = CALayer()
        //        let myImage = #imageLiteral(resourceName: "yellowBlue").cgImage
        //        myLayer.frame = chartView.bounds
        //        myLayer.contents = myImage
        //        chartView.layer.insertSublayer(myLayer, at: 0)
        
        setupAxes()
    }
    
    func setupAxes() {
        
        func setupYAxis(_ axis: YAxis) {
            
            axis.axisMinimum = 0
            axis.drawAxisLineEnabled = false
            axis.drawLabelsEnabled = false
            axis.drawGridLinesEnabled = false
        }
        
        setupYAxis(chartView.leftAxis)
        setupYAxis(chartView.rightAxis)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .darkGray
        xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineWidth = 6.0
        xAxis.axisLineColor = #colorLiteral(red: 0.1815032431, green: 0.5247105002, blue: 1, alpha: 0.6856569102)
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.gridColor = #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
        xAxis.axisLineDashLengths = [0] //Any value
        xAxis.gridLineWidth = 1.0
        
        let renderer = CustomXAxisRenderer(for: chartView)
        renderer.subAxisLineColor = #colorLiteral(red: 0, green: 0.6158003211, blue: 1, alpha: 0.27)
        chartView.xAxisRenderer = renderer
        
        chartView.extraBottomOffset = 16.0
    }
    
    func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        setChartData()
    }
    
    func setChartData() {
        
        let data = CombinedChartData()
        data.lineData = generateLineData()
        //        data.barData = generateBarData()
        //        data.bubbleData = generateBubbleData()
        //        data.scatterData = generateScatterData()
        //        data.candleData = generateCandleData()
        
        //chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
    
    func generateLineData() -> LineChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let entries1 = (0..<ITEM_COUNT).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, y: Double(arc4random_uniform(25) + 25))
        }
        let entries2 = (0..<ITEM_COUNT).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
        }
        
        let set1 = BarChartDataSet(values: entries1, label: "Bar 1")
        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left
        
        let set2 = BarChartDataSet(values: entries2, label: "")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 10)
        set2.axisDependency = .left
        
        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth
        
        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        return data
    }
    
    func generateScatterData() -> ScatterChartData {
        let entries = stride(from: 0.0, to: Double(ITEM_COUNT), by: 0.5).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: i+0.25, y: Double(arc4random_uniform(10) + 55))
        }
        
        let set = ScatterChartDataSet(values: entries, label: "Scatter DataSet")
        set.colors = ChartColorTemplates.material()
        set.scatterShapeSize = 4.5
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: 10)
        
        return ScatterChartData(dataSet: set)
    }
    
    func generateCandleData() -> CandleChartData {
        let entries = stride(from: 0, to: ITEM_COUNT, by: 2).map { (i) -> CandleChartDataEntry in
            return CandleChartDataEntry(x: Double(i+1), shadowH: 90, shadowL: 70, open: 85, close: 75)
        }
        
        let set = CandleChartDataSet(values: entries, label: "Candle DataSet")
        set.setColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1))
        set.decreasingColor = UIColor(red: 142/255, green: 150/255, blue: 175/255, alpha: 1)
        set.shadowColor = .darkGray
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        
        return CandleChartData(dataSet: set)
    }
    
    func generateBubbleData() -> BubbleChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> BubbleChartDataEntry in
            return BubbleChartDataEntry(x: Double(i) + 0.5,
                                        y: Double(arc4random_uniform(10) + 105),
                                        size: CGFloat(arc4random_uniform(50) + 105))
        }
        
        let set = BubbleChartDataSet(values: entries, label: "Bubble DataSet")
        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = true
        
        return BubbleChartData(dataSet: set)
    }
}

extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}

extension ViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        //guard Int(value) % 2 != 0 else { return "" }
        return months[Int(value) % months.count]
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
