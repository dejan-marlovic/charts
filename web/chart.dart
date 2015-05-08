import "dart:html";
import "dart:core";
import "dart:math";
abstract class Chart
{
  // param: container - DivElement, div container for canvas element that will contain the graph.
  // param: chartDate - List containing chart data
  // param: chartColors - List containing chartColors
  Chart(DivElement container, List chartData, List charColors)
  {
    _chartData = chartData;
    _container = container;
    _canvas = new CanvasElement();
    _container.append(_canvas);
    _context = _canvas.getContext("2d");
    _canvas.width = _container.getBoundingClientRect().width.floor();
    _canvas.height = _container.getBoundingClientRect().height.floor();
    _chartData = chartData;
    _container = container;
    _chartColors = charColors;
  }
  
  void draw();

CanvasElement _canvas;
DivElement _container;
List _chartData;
var _context;
List _chartColors;
}

class  BarChart extends Chart
{
// param: margin - int, distince between the chart bars.
// param: chartData - List<List<double>>, chart data representing each part of the bar. List of List<double> is used so that each part of the bar can be represented.
// param: xAxisLabels - List<String>, List of x-axis labels.
// param: yAxisLabels - List<String>, List of y-axis labels.(not implemented).
// param: font - String, font for x-axis labels in context object format. 
// param: xAxisLabelsRoom - int, room to be made for xAxisLabels.
// param: barValuePrecision - int, precision for bar value labels.
  BarChart({DivElement container:null, int margin:0, List<List<double>> chartData:null, List<String> chartColors:null, List<String> xAxisLabels:null, List<String> yAxisLabels:null, String font:"bold 12px sans-serif", int xAxisLabelsRoom:40, int yAxisOffset:25, int barValuePrecision:3}):super(container, chartData, chartColors)  
  {
    _margin = margin;
    _xAxisLabels = xAxisLabels;
    _yAxisLabels = yAxisLabels;
    _font = font;
    _barValuePrecision = barValuePrecision;
    _xAxisLabelsRoom = xAxisLabelsRoom;
    _yAxisOffset = yAxisOffset;
  }

  // Method for drawing a  bar chart
  void draw() 
  {
    int numOfBars = _chartData.length;
    double barWidth;
    double ratio;
    double largestValue;
    int graphAreaWidth = _canvas.width;
    int graphAreaHeight = _canvas.height;
    int bar;
    double barValue;

    // If x axis labels exist then make room
    if (_xAxisLabels.length > 0) 
    {
      graphAreaHeight -= _xAxisLabelsRoom +_yAxisOffset;
    }
    
    // Calculate dimensions of the bar
    barWidth = (graphAreaWidth / numOfBars) - (_margin * 2);
    
    // Determine the largest bar value
    largestValue = 0.0;
    barValue = 0.0;   
    for (bar = 0; bar < _chartData.length; bar += 1) 
    {
      //sum all the parts of a bar
      barValue = sumTo(_chartData[bar], _chartData[bar].length);
      
      if (barValue > largestValue) 
      {
        largestValue = barValue;
      }
    }
    // Set the ratio of current bar compared largest value
    ratio = graphAreaHeight / largestValue;
    
    //For each bar
    for (bar = 0; bar < _chartData.length; bar += 1) 
    {
      double barValue  = sumTo(_chartData[bar], _chartData[bar].length);
      double top = 0.0;
      double left = 0.0;
      
      //first part of the bars start att y = graph area height, since the top corner of the graph area is 0  
      double bottom = graphAreaHeight.toDouble() +_yAxisOffset;
      
      //For each part of the bar
      int color = 0;
      for (int cat = 0; cat < _chartData[bar].length; cat++) 
      {          
        //calculate x and y value for each part of the bar
        left = _margin + bar * graphAreaWidth / numOfBars;
        double height = _chartData[bar][cat] * ratio;
        top = bottom - height;
        // Draw bar background for each part
        _context.fillStyle = "#333";
        _context.fillRect(left, top, barWidth, height); 
        //pick next color from chosen colors for each part of bar, if all have been used repeat
        color++;
        if (color == _chartColors.length) 
          color = 0;
        //fill in the color of each part of the bar 
        _context.fillStyle = _chartColors[color];
        _context.fillRect(left, top, barWidth, height);   
        //previous part of the bars top is next parts bottom
        bottom = top;
      }
    
    // Write bar value
     _context.fillStyle = "black";
     _context.font = _font;
     _context.textAlign = "center";
     // Use try / catch to stop IE 8 from going to error town
    try 
    {
      //using last last top which is bar top
     _context.fillText(barValue.toStringAsPrecision(_barValuePrecision),left + barWidth/2,top - 4);
    } catch (ex) {}
   
    if (_xAxisLabels.length > 0) 
    {        
     // Use try / catch to stop IE 8 from going to error town        
     _context.fillStyle = "black";
     _context.font = _font;
     _context.textAlign = "center";
     try 
     {
       _context.fillText(_xAxisLabels[bar],left + barWidth/2 ,_canvas.height - _yAxisOffset);
     } catch (ex) {}
     }
   }
  }
  double sumTo(a, i) 
  {
    var sum = 0;
    for (var j = 0; j < i; j++) 
    {
      sum += a[j];
    }
    return sum;
  }
  //private fields
  DivElement _container;
  var _context;
  CanvasElement _canvas;

  //public fields
  int _margin;  
  List<List<double>> _chartData;
  List<String> _chartColors;
  List<String> _xAxisLabels;
  List<String> _yAxisLabels;
  int _xAxisLabelsRoom;
  String _font; 
  int _yAxisOffset;
  int _barValuePrecision;

  //getters and setters for public fields
  int get margin => _margin;
  List<List<double>> get chartData => _chartData;
  int get  yAxisOffset =>  _yAxisOffset;
  String get font => _font;
  List<String> get chartColors => _chartColors;
  List<String> get xAxisLabels => _xAxisLabels;
  List<String> get yAxisLabels => _yAxisLabels;
  int get xAxisLabelsRoom => _xAxisLabelsRoom;
  int get barValuePrecision => _barValuePrecision;
  
  set margin(int margin) => _margin = margin;
  set yAxisOffset(int yAxisOffset) => _yAxisOffset = yAxisOffset;
  set chartColors(List<String> chartColors) => _chartColors = chartColors;
  set xAxisLabels(List<String> xAxisLabels) => _xAxisLabels = xAxisLabels;
  set font(String font) => _font = font;
  set xAxisLabelsRoom(int xAxisLabelsRoom) => _xAxisLabelsRoom = xAxisLabelsRoom;
  set barValuePrecision(int barValuePrecision) => _barValuePrecision = barValuePrecision;
}

class PieChart extends Chart
{
  // param: includeLabels - boolean, determines whether to include the specified labels when drawing the chart. If false, the labels are stored in the pie chart but not drawn by default. You can draw a label for a segment with  the drawLabel method.
  // param: chartData - List<int>, List of data items. Should be positive integer adding up to 360.
  // param: labels - List<String>, List of labels. Should have at least as many items as data.
  // param: chartColors List of Lists (string) chartColors. First is used to draw segment, second to draw a selected segment.
  PieChart({DivElement  container, bool includeLabels:false, List <int> chartData:null, List<String> labels : null, List<List<String>> chartColors : null}):super(container, chartData, chartColors)  
  {
    _includeLabels = includeLabels;
    _labels = labels;
  }
  void select(int segment)
  {
    for(int i=0; i <_chartData.length; i++)
    {
      drawSegment(_canvas,_context,segment,_chartData[segment], true, _includeLabels);
    }  
  }

  void draw() 
  {
    for (var i = 0; i < _chartData.length; i++) 
      drawSegment(_canvas, _context, i, _chartData[i], false, _includeLabels);
  }

  void drawSegment (CanvasElement canvas, var context, int i, int size, bool isSelected, bool includeLabels) 
  {
    context.save();
    int centerX = (canvas.width / 2).floor();
    int centerY = (canvas.height / 2).floor();
    int radius  = (canvas.width / 2).floor();
    
    var startingAngle = degreesToRadians(sumTo(_chartData, i));
    var arcSize = degreesToRadians(size);
    var endingAngle = startingAngle + arcSize;
  
    context.beginPath();
    context.moveTo(centerX, centerY);
    context.arc(centerX, centerY, radius, startingAngle, endingAngle, false);
    context.closePath();
    
    isSelected ? context.fillStyle = _chartColors[i][1] : context.fillStyle = _chartColors[i][0];
    
    context.fill();
    context.restore();
  
    if (includeLabels && (_labels.length > i)) 
    {
      drawSegmentLabel(canvas, context, i, isSelected);
    }
  }
  
  void drawSegmentLabel(CanvasElement canvas, var context, int i, bool isSelected) 
  {
    context.save();
    var x = (canvas.width / 2).floor();
    var y = (canvas.height / 2).floor();
    var angle;
    var angleD = sumTo(_chartData, i);
    var flip = (angleD < 90 || angleD > 270) ? false : true;

    context.translate(x, y);
    if (flip) 
    {
      angleD = angleD-180;
      context.textAlign = "left";
      angle = degreesToRadians(angleD);
      context.rotate(angle);
      context.translate(-(x + (canvas.width * 0.5))+15, -(canvas.height * 0.05)-10);
    }
    else 
    {
      context.textAlign = "right";
      angle = degreesToRadians(angleD);
      context.rotate(angle);
    }
    //context.textAlign = "right";
    int fontSize = (canvas.height / 25).floor();
    context.font = fontSize.toString() + "pt Helvetica";

    var dx = (canvas.width * 0.5).floor() - 10;
    var dy = (canvas.height * 0.05).floor();
    context.fillText(_labels[i], dx, dy);

    context.restore();
  }
  
  void drawLabel (int i) 
  {
    drawSegmentLabel(_canvas, _context, i,  false);
  }
  // helper functions
  double degreesToRadians (degrees) 
  {
    return (degrees * PI)/180;
  }
  
  int sumTo(a, i) 
  {
    var sum = 0;
    for (var j = 0; j < i; j++) {
      sum += a[j];
  }
    return sum;
  }
  //public fields
  bool _includeLabels;
  List<int> _chartData;
  List<String> _labels;
  List<List<String>> _chartColors;
  
  //getters och setters for public fields
  get includeLabels => _includeLabels;
  get chartData => _chartData;
  get labels => _labels;
  get chartColors => _chartColors;
  set includeLabels(bool includeLabels) => _includeLabels = includeLabels;
  set chartData (List<int> chartData) => _chartData = chartData;
  set labels (List<String> labels) => _labels = labels;
  set chartColors (List<List<String>> chartColors) => _chartColors = chartColors;
}